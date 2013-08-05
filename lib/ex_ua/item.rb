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
    # Actual download url.
    # You can add ?fs_id=server_id  param to download form #additional_servers
    # @return[String] download_url
    def download_url
      "#{ExUA::BASE_URL}#{url}"
    end

    def url
      @url ||= "/load/#{self.id}"
    end
  end
end
