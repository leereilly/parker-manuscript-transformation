module DMS
  module Transformation
    class NormalSequence
      attr_accessor :manuscript, :filename

      def initialize(manuscript = nil, filename = nil)
        @manuscript = manuscript
        @filename = filename
        self.serialize
      end
      
      def serialize()
        puts "Serializing to N3 @ #{@filename}" if DMS::debug
        RDF::Writer.open("#{@filename}") do |writer|
          
          # NAMESPACE PREFIXES
          writer.prefixes = {
            :dc     => RDF::URI('http://purl.org/dc/terms/'),
            :dms    => RDF::URI('http://dms.stanford.edu/ns/'),
            :exif   => RDF::URI('http://www.w3.org/2003/12/exif/ns#'),
            :ore    => RDF::URI('http://www.openarchives.org/ore/terms/'),
            :rdf    => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#')
          }
          
          # CANVASES
          @manuscript.ordered_pages.each do |page|

            writer << RDF::Statement.new({
              :subject   => RDF::Resource("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}"),
              :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
              :object    => RDF::Resource("#{writer.prefixes[:dms]}canvas")
            })

            writer << RDF::Statement.new({
              :subject   => RDF::Resource("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}"),
              :predicate => RDF::Resource("#{writer.prefixes[:exif]}width"),
              :object    => RDF::Literal(page.get_no_crop_image.width) 
            })

            writer << RDF::Statement.new({
              :subject   => RDF::Resource("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}"),
              :predicate => RDF::Resource("#{writer.prefixes[:exif]}height"),
              :object    => RDF::Literal(page.get_no_crop_image.height)
            })

            writer << RDF::Statement.new({
              :subject   => RDF::Resource("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}"),
              :predicate => RDF::Resource("#{writer.prefixes[:dc]}title"),
              :object    => page.label
            })

          end
        end
      end      
    end
  end
end