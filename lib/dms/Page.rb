module DMS
  class Page
    attr_accessor :number, :label, :type, :images

    def initialize(number = nil, label = nil, type = nil, images = [])
      @number, @label, @type, @images = number, label, type, images
    end

    def add_image(image)
      @images << image
    end

    def get_no_crop_image()
      @images.each do |image|
        return image if image.type == 'NC'
      end
    end

    def get_tight_crop_image()
      @images.each do |image|
        return image if image.type == 'TC'
      end
    end
  end
end