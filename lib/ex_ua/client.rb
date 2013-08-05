module ExUA
  # Client for ExUA
  # @example Usage
  #   client = ExUA::Client.new
  #   categories = client.base_categories('ru')
  #
  class Client
    attr_reader :agent
    private :agent

    def initialize
      @agent = Mechanize.new
    end

    def inspect
      "#<#{self.class}>"
    end

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
      agent.get("#{ExUA::BASE_URL}#{url}")
    end
  end
end
