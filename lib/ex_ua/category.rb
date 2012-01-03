# @author Andrii Dmytrenko
module ExUA
  # Represents a category
  # @example Usage
  #   #You usually get categories thru ExUA::Client object
  #   client = ExUA::Client.new
  #   categories = client.base_categories('ru')
  #   sub_categories = categories.first.categories
  #   items = sub_categories.first.categories.first.items
  class Category
    attr_reader :id,:parent, :url

    # @param[ExUA::Client] ex_ua client
    # @param[Fixnum] id Category id
    # @param[Hash] options
    def initialize(ex_ua, id, options={})
      @ex_ua,@id = ex_ua, id
      @url = options[:url] || url_from_id(id)
      @name = options.delete(:name)
      @parent = options.delete(:parent)
    end

    def to_s
      "id:#{id} name:'#{name}' page: #{page}"
    end

    def inspect
      "#<#{self.class}: #{to_s}>"
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
      @picture ||= page_content.root.xpath("//link[@rel='image_src']/@href").first.value.split("?").first
    end

    # List of subcategories
    # @return [Array<ExUA::Category>]
    def categories
      page_content.search('table.include_0 a b').map do |link|
        if match = link.parent.attributes["href"].value.match(%r{/view/(?<id>\d+)\?r=(?<r>\d+)})
          Category.new(@ex_ua,match[:id], parent: self, name: link.text)
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
      Category.new(@ex_ua, self.id, url: next_url)
    end

    # Previous category
    # @return [ExUA::Category]
    def prev
      Category.new(@ex_ua, self.id, url: prev_url)
    end

    # Current page number
    # @return [Fixnum]
    def page
      CGI.parse(URI.parse(@url).query||"")["p"].first.to_i || 0
    end

    # Download items
    # @return [Array<ExUA::Item>]
    def items
      table_rows = page_content.search('table.list tr')
      table_rows.map do |tr|
        tr.search("a[title!='']")
      end.reject(&:empty?).map do |links|
        Item.new.tap do |item|
          links.each { |link|
            case link.attributes["href"].value
            when %r{^/get/}
              item.title = link.attributes["title"].value
              item.id = link.attributes["href"].value.match(%r{^/get/(\d+)})[1].to_i
            when %r{^/load}
              item.additional_servers||=[]
              item.additional_servers << link.attributes["title"].value.match(%r{fs(\d+)})[1].to_i
            end
          }
        end
      end
    end

    protected

    def page_content
      @page_content||=@ex_ua.agent.get("#{ExUA::BASE_URL}#{@url}")
    end

    def url_from_id(id)
      "/view/#{id}"
    end

    def next_url
      @next_url||=page_content.root.xpath("//link[@rel='next']/@href").first.tap{|a| a.value if a}
    end

    def prev_url
      @prev_url||=page_content.root.xpath("//link[@rel='prev']/@href").first.tap{|a| a.value if a}
    end
  end
end
