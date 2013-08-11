require 'httparty'
require 'nokogiri'
require 'singleton'
require 'addressable/uri'

module ExUA
  # Client for ExUA
  # @example Usage
  #   client = ExUA::Client.new
  #   categories = client.base_categories('ru')
  #
  class ExUAFetcher
    include HTTParty
    no_follow true
    def self.get_redirect(uri)
      get Addressable::URI.parse(uri).normalize.to_s
    rescue HTTParty::RedirectionTooDeep => e
      e.response["location"]
    end
  end
  class Client
    include Singleton
    KNOWN_BASE_CATEGORIES = %w[video audio images texts games software]
    class<<self
      [:available_languages, :base_categories, :search].each do |met|
        define_method(met) do |*args| #delegate to instance
          instance.public_send(met, *args)
        end
      end
    end
    # List of available languages
    # @return [Array<String>]
    def available_languages
      @available_langauges ||= get('/').search('select[name=lang] option').inject({}){|acc,el| acc[el.attributes["value"].value]=el.text;acc}
    end

    # List of base categories for a given language
    # @param[String] lang Language
    # @example Usage
    #   client.base_categories('ru')
    # @return [Array<ExUA::Category>]
    def base_categories(lang)
      KNOWN_BASE_CATEGORIES.map{|cat| Category.new(url: "/#{lang}/#{cat}")}
    end

    def get(request_uri)
      Nokogiri.parse(HTTParty.get(Addressable::URI.join(ExUA::BASE_URL,request_uri).to_s).body)
    end

    private
    def base_categories_names
      KNOWN_BASE_CATEGORIES
    end
  end
end
