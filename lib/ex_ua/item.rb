require 'addressable/uri'
# @author Andrii Dmytrenko
module ExUA
  # Download item
  class Item < Struct.new(:id, :title, :additional_servers)
    def self.parse(links)
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
    # URI with content-disposition: attachment
    def retrieve_real_load_url
      retrieve_real_url(load_uri)
    end

    def retrieve_real_get_url
      retrieve_real_url(get_uri)
    end

    # @params[String, File] save_to Optional. File location to save content to
    # @return[HTTParty::Response] Response
    def download(save_to=nil)
      response = HTTParty.get(retrieve_real_get_url)
      File.write(save_to, response.body) if save_to
      response
    end

    # Returns response with headers(includes content-type, content-lenght)
    # @return[HTTParty::Response]
    def head
      @head ||= HTTParty.head(retrieve_real_get_url)
    end

    # Actual download url with ex.ua included
    # You can add ?fs_id=server_id  param to download form #additional_servers
    # @return[Addressable::URI]

    def get_uri
      @get_url ||= Addressable::URI.join(ExUA::BASE_URL,"/get/#{self.id}")
    end

    # URI with content-disposition: attachment
    def load_uri
      @load_url ||= Addressable::URI.join(ExUA::BASE_URL, "/load/#{self.id}")
    end

    private
    def retrieve_real_url(uri)
      ExUA::ExUAFetcher.get_redirect(uri)
    end
  end
end
