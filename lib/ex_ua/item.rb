require 'addressable/uri'
# @author Andrii Dmytrenko
module ExUA
  # Download item
  class Item < Struct.new(:id, :title, :additional_servers)
    def self.parse_links(links)
      self.new.tap do |item|
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

    # Queries ex.ua to get a real url to fetch data from (follows redirect)
    def retrieve_real_load_url
      retrieve_real_url(download_uri)
    end

    def retrieve_real_get_url
      retrieve_real_url(get_uri)
    end

    # Actual download url with ex.ua included
    # You can add ?fs_id=server_id  param to download form #additional_servers
    # @return[Addressable::URI]

    def get_uri
      @get_url ||= Addressable::URI.join(ExUA::BASE_URL,"/get/#{self.id}")
    end

    def download_uri
      @downoadload_url ||= Addressable::URI.join(ExUA::BASE_URL, "/load/#{self.id}")
    end

    private
    def retrieve_real_url(uri)
      ExUA::ExUAFetcher.get_redirect(uri)
    end
  end
end
