require 'httparty'
require 'nokogiri'

module ExUA
  # Client for ExUA
  # @example Usage
  #   client = ExUA::Client.new
  #   categories = client.base_categories('ru')
  #
  class Client
    # List of available languages
    # @return [Array<String>]
    def available_languages
      @available_langauges||=get('/').search('select[name=lang] option').inject({}){|acc,el| acc[el.attributes["value"].value]=el.text;acc}
    end

    # List of base categories for a given language
    # @param[String] lang Language
    # @example Usage
    #   client.base_categories('ru')
    # @return [Array<ExUA::Category>]
    def base_categories(lang)
      ExUA::KNOWN_BASE_CATEGORIES.map{|cat| Category.new(self, url: "/#{lang}/#{cat}")}
    end

    def get(url)
      Nokogiri.parse(HTTParty.get("#{ExUA::BASE_URL}#{url}").body)
    end
  end
end
