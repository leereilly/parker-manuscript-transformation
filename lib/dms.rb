$:.unshift File.dirname(__FILE__)  # For use/testing when no gem is installed

require 'rubygems'

require 'nokogiri'

require 'rdf'
require 'rdf/n3'

require 'dms/Manuscript'
require 'dms/Page'
require 'dms/Image'

require 'dms/transformation/Manifest'
require 'dms/transformation/Prefix'
require 'dms/transformation/NormalSequence'
require 'dms/transformation/ImageCollection'

module DMS
  VERSION = "0.0.1"
  
  class << self
    attr_accessor :debug
  end

  self.debug = false
end