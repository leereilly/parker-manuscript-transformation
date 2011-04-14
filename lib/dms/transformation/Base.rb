module DMS
  module Transformation
    class Base
      attr_accessor :manuscript, :filename

      def initialize(manuscript = nil, filename = nil)
        @manuscript = manuscript
        @filename = filename
        self.serialize
      end
      
      def serialize
        
      end
    end
  end
end