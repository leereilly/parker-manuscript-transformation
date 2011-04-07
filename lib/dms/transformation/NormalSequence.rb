module DMS
  module Transformation
    class NormalSequence
      attr_accessor :manuscript

      def initialize(manuscript = nil)
        @manuscript = manuscript
      end
    end
  end
end