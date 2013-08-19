# @author Andrii Dmytrenko
require 'addressable/uri'
module ExUA
  # Represents a category
  # @example Usage
  #   #You usually get categories thru ExUA::Client object
  #   categories = ExUA::Client.base_categories('ru')
  #   sub_categories = categories.first.categories
  #   items = sub_categories.first.categories.first.items
  class Category
    class NotFound < StandardError; end
    attr_reader :id,:parent, :uri

    # @param[ExUA::Client] ex_ua client
    # @param[Fixnum] id Category id
    # @param[Hash] options
    def initialize(options={})
      @id = options[:id]
      @uri = Addressable::URI.parse(options[:url] || url_from_id(id))
      @uri.site = ExUA::BASE_URL
      @name = options.delete(:name)
      @parent = options.delete(:parent)
    end

    def to_s
      "id:#{id} name:'#{name}' page: #{page}"
    end

    # Canonical url
    # @return [String]
    def canonical_url
      @canonical_url ||= page_content.root.xpath("//link[@rel='canonical']/@href").first.value
    end

    # Category name
    # @return [String]
    def name
      @name ||= page_content.root.xpath("//meta[@name='title']/@content").first.value
    end

    # Category description
    # @return [String]
    def description
      @description ||= page_content.root.xpath("//meta[@name='description']/@content").first.value
    end

    # Category picture
    # @return [String] url for a picture
    def picture
      @picture ||= (
        pic = page_content.root.xpath("//link[@rel='image_src']/@href").first
        pic && pic.value.split("?").first
      )
    end

    # List of subcategories
    # @return [Array<ExUA::Category>]
    def categories
      page_content.search('table.include_0 a b').map do |link|
        if match = link.parent.attributes["href"].value.match(%r{(?<url>[^?]+)\?r=(?<r>\d+)})
          Category.new(parent: self, url: match['url'], name: link.text)
        end
      end.compact
    end

    # Is there a next category?
    def next?
      !!next_url
    end

    # Is there a previous category?
    def prev?
      !!prev_url
    end

    # Next category
    # @return [ExUA::Category]
    def next
      raise NotFound, "No link to a next category found" unless next?
      Category.new(id: self.id, url: next_url)
    end

    # Previous category
    # @return [ExUA::Category]
    def prev
      raise NotFound, "No link to a previous category found" unless prev?
      Category.new(id: self.id, url: prev_url)
    end

    # Current page number
    # @return [Fixnum]
    def page
      uri.query_values["p"].to_i rescue 0
    end

    # Category's path
    # @return [String]
    def path
      uri.path
    end

    # Download items
    # @return [Array<ExUA::Item>]
    def items
      table_rows = page_content.search('table.list tr')
      table_rows.map do |tr|
        tr.search("a[title!='']")
      end.reject(&:empty?).map do |links|
        Item.parse(links)
      end
    end

    protected

    def page_content
      @page_content||=ExUA::Client.instance.get(uri.request_uri)
    end

    def url_from_id(id)
      "/view/#{id}"
    end

    def next_url
      @next_url||=(
        e = page_content.root.xpath("//link[@rel='next']/@href").first
        e && e.value
      )
    end

    def prev_url
      @prev_url||=(
        e = page_content.root.xpath("//link[@rel='prev']/@href").first
        e && e.value
      )
    end
  end
end
