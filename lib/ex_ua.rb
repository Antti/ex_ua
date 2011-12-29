module ExUA
  BASE_URL='http://ex.ua'
end
require "ex_ua/version"
require "ex_ua/item"
require "ex_ua/category"
require 'mechanize'

module ExUA
  # Client for ExUA
  # @example Usage
  #   client = ExUA::Client.new
  #   categories = client.base_categories('ru')
  #
  class Client
    attr_reader :agent

    def initialize
      @agent = Mechanize.new
    end

    def inspect
      "#<#{self.class}>"
    end

    # List of available languages
    def available_languages
      @available_langauges||=@agent.get(BASE_URL).search('select[name=lang] option').inject({}){|acc,el| acc[el.attributes["value"].value]=el.text;acc}
    end

    # List of base categories for a given language
    # @param[String] lang Language
    # @example
    #   client.base_categories('ru')
    def base_categories(lang)
      %w[video audio images texts games software].map{|cat| Category.new(self, nil, url: "/#{lang}/#{cat}")}
    end
  end
end
