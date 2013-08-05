require 'ex_ua'
module StubbedExUAClient
  BASE_URL = File.join(File.expand_path('..', __FILE__), 'data')
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
