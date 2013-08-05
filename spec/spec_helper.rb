require 'ex_ua'
module StubbedExUAClient
  BASE_URL = File.expand_path('../data', __FILE__)
  def client
    @client ||= (
      c=ExUA::Client.new
      c.define_singleton_method(:get) do |page|
        page = 'index.html' if page == '/'
        Nokogiri.parse(File.new("#{BASE_URL}/#{page}", external_encoding: Encoding::UTF_8).read)
      end
      c
    )
  end
end

RSpec.configure do |config|
  config.include StubbedExUAClient
end
