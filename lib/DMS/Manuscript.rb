module DMS
  class Manuscript
    attr_accessor :name, :ordered_pages, :original_filename

    DEFAULT_VIEW_MODE = 2
    LEVELS = 6

    def initialize(name = nil, ordered_pages = [], original_filename = nil)
      @name, @ordered_pages, @original_filename = name, ordered_pages, original_filename
    end

    def add_page(page)
      @ordered_pages << page
    end

    def to_json
      collection_hash = Hash.new
      collection_hash['objectId'] = nil
      collection_hash['title'] = self.name
      collection_hash['id'] = self.name
      collection_hash['defaultViewMode'] = DEFAULT_VIEW_MODE
      collection_hash['pages'] = Array.new   

      self.ordered_pages.each do |page|
        page_hash = Hash.new
        page_hash['levels'] = LEVELS
        page.images.each do |image|
          if image.type == 'TC'
            page_hash['identifier'] = image.jp2Path
            page_hash['width'] = image.width
            page_hash['height'] = image.height  
            page_hash['title'] = page.label  
          end
        end
        collection_hash['pages'] << page_hash
      end 

      return collection_hash.to_json
    end
  end
end