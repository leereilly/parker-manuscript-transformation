module DMS
  module Transformation
    class Prefix
      PREFIXES = Hash.new(
        :dc     => RDF::URI('http://purl.org/dc/terms/'),
        :dms    => RDF::URI('http://dms.stanford.edu/ns/'),
        :exif   => RDF::URI('http://www.w3.org/2003/12/exif/ns#'),
        :ore    => RDF::URI('http://www.openarchives.org/ore/terms/'),
        :rdf    => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#')
      )

      def self.get_prefixes
        return PREFIXES
      end
    end
  end
end