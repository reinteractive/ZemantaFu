# ZemantaFu
require 'net/http'
require 'rubygems'
require 'xmlsimple'

module ZemantaFu
  extend self
  # refer to http://developer.zemanta.com/docs/suggest/ for valid options
  def search(text, options = {})
    # tags - keywords
    # in-text links
    # categories
    
    options[:method] ||= "zemanta.suggest"
    options[:format] ||= "xml"
    options[:return_categories] ||= "dmoz"
    options[:api_key] ||= "o26uvljcvr6q9l0zf155difg"
    # options[:return_images] ||= 0
    options[:markup_limit] ||= 1000
    options[:articles_limit] ||= 1000
    
    options[:text] = text
    
    [:api_key].each do |k|
      raise "Missing required key :#{k} in options." unless options.has_key?(k)
    end
    
    gateway = 'http://api.zemanta.com/services/rest/0.0/'
    res = Net::HTTP.post_form(URI.parse(gateway), options.stringify_keys)
    data = XmlSimple.xml_in(res.body)
    res = ResponseData.new(data) 
    
    # clean up top level arrays so that we can do
    #   search("poker").articles
    # instead of 
    #   search("poker"").articles[0].article 
    res.keys.each do |k|
      ks = k.singularize
      if res[k][0] && res[k][0].is_a?(Hash) && res[k][0].keys.include?(ks)
        res[k] = res[k][0][ks]
      else
        res[k] = res[k][0]
      end
    end
    # ensure there's something there for everthing
    ["articles", "images", "keywords", "categories"].each do |k|
      res[k] ||= []
    end
    # fix markup section
    if res["markup"]["links"] == [{}]
      res["markup"]["links"] = []
    else
      res["markup"]["links"] = res.markup.links.first.link
      res["markup"]["links"].each_with_index do |link, index|
        res["markup"]["links"][index]["targets"] = res["markup"]["links"][index]["target"]
      end
    end
    return res
  end

  # ResponseData modified from the rbing project https://raw.github.com/mikedemers/rbing/master/lib/rbing.rb
  class ResponseData < Hash
    
    def save(filename)
      File.open(filename, 'w') do |out|
        YAML.dump(self, out)
      end
    end
    
    private
    
    def initialize(data={})
      data.each_pair {|k,v| self[k.to_s] = deep_parse(v) }
    end
    
    def deep_parse(data)
      case data
      when Hash
        self.class.new(data)
      when Array
        data.map {|v| deep_parse(v) }
      else
        data
      end
    end
    
    def method_missing(*args)
      name = args[0].to_s
      res = nil
      if has_key? name
        res = self[name] 
      else
        camelname = name.split('_').map {|w| "#{w[0,1].upcase}#{w[1..-1]}" }.join("")
        if has_key? camelname
          res = self[camelname]
        else
          super *args
        end
      end
      if res.nil?
        super *args
      else
        # Zemanta returns all final values as arrays... get rid of this so, for example
        # res.status = "ok" and not ["ok"]
        if res.is_a?(Array) && res.size == 1 && res.first.is_a?(String) == true
          return res.first
        else
          return res
        end
      end
    end
    
  end

  # 
  class Parameters
    OPTION_KEYS = [:parameter, :description, :required, :possible_values, :default_value]
    OPTIONS = [
      [:method,	"Method on the server",	true,	"zemanta.suggest", "zemanta.suggest"],
      [:api_key, "Your API key", true, "string", nil],
      [:text,	"Input text (clear text or HTML)", true, "string", nil],
      [:format, "requested output format", true, ["xml", "json", "wnjson", "rdfxml"], "xml"],
      [:return_rdf_links, "return URIs of Linking Open Data entities", false, [0, 1], nil],
      [:return_categories, "categorize into specified categorization scheme", false, ["dmoz","partner ID"], "dmoz"],
      [:return_images, "return related images (default is yes) This can cause dramatic performance improvements", false, [0, 1], "yes"],
      [:return_keywords, "return keywords (default is yes) This can affect performance slightly positively", false,  [0, 1], "yes"],
      [:emphasis,	%(terms to "emphasise", even when not present in text. All related articles are then required to have this term.), false, "string", nil],
      [:text_title, "[NEW since August 2010]	Title of the text you are sending. Helps the text understanding algorithm.",	false, "string", nil],
      [:personal_scope, "return only personalized related articles and images", false, [0, 1], nil],
      [:markup_limit,	"Number of in-text links to return (default: depending on the number of input words, 1 per each 10 words, and it maxes out at 10)", false, "number", 10],
      [:images_limit,	"Number of images to return (default:24)", false, "number", 24],
      [:articles_limit, "Number of articles to return (default:10)", false,	"number", 10],
      [:articles_max_age_days,	"Maximum age of returned articles (default: no limit)", false, "number", nil],
      [:articles_highlight, "[NEW since August 2010] Should a highlighted search snippet for each article be returned, where available (default: no)", false, "number", 0],
      [:image_max_w, "Maximum image width (default: 300)", false, "number", 300],
      [:image_max_h, "Maximum image height (default: 300)",	false, "number", 300],
      [:sourcefeed_ids, "ID for personalized related articles", false, nil],
      [:flickr_user_id, "flickr ID of the user", false, nil],
      [:pixie, "the chosen Zemanta signature icon", false, nil]
    ]
  end
  
end