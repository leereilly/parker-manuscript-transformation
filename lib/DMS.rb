require 'rubygems'

require 'rdf'
require 'rdf/n3'

require 'DMS/Manuscript'
require 'DMS/Page'
require 'DMS/Image'

require 'DMS/transformations/Manifest'
require 'DMS/transformations/Prefix'
require 'DMS/transformations/NormalSequence'
require 'DMS/transformations/ImageCollection'

module DMS
  VERSION = "0.0.1"
  
  class << self
    attr_accessor :debug
  end

  self.debug = false
end