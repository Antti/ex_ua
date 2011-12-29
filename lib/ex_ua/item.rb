module ExUA
  # Download item
  class Item < Struct.new(:id, :title, :download_url, :additional_servers)
  end
end