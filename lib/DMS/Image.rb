module DMS
  class Image
    attr_accessor :type, :path, :width, :height

    def initialize(type = nil, path = nil, width = nil, height = nil)
      @type, @path, @width, @height, @label = type, path, width, height
    end
  end
end