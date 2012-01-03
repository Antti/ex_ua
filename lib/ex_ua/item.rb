# @author Andrii Dmytrenko
module ExUA
  # Download item
  class Item < Struct.new(:id, :title, :additional_servers)
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
