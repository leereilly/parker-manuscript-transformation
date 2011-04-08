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
          iteration_count = 0
          
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
            iteration_count = iteration_count + 1
            canvas_subject = RDF::URI("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}")
            
            writer << RDF::Statement.new({
              :subject   => canvas_subject,
              :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
              :object    => RDF::Resource("#{writer.prefixes[:dms]}canvas")
            })

            writer << RDF::Statement.new({
              :subject   => canvas_subject,
              :predicate => RDF::Resource("#{writer.prefixes[:exif]}width"),
              :object    => RDF::Literal(page.get_no_crop_image.width) 
            })

            writer << RDF::Statement.new({
              :subject   => canvas_subject,
              :predicate => RDF::Resource("#{writer.prefixes[:exif]}height"),
              :object    => RDF::Literal(page.get_no_crop_image.height)
            })

            writer << RDF::Statement.new({
              :subject   => canvas_subject,
              :predicate => RDF::Resource("#{writer.prefixes[:dc]}title"),
              :object    => page.label
            })

            # SEQUENCE
            # <http://dmstech.groups.stanford.edu/ccc001/manifest/NormalSequence> a dms:Sequence,
            #         ore:Aggregation,
            #         rdf:List;
            #     ore:aggregates <http://dmss.stanford.edu/dmstech/CCC001/100R>,
            #         <http://dmss.stanford.edu/dmstech/CCC001/100V>,
            #         <http://dmss.stanford.edu/dmstech/CCC001/ivV>;
            #     rdf:first <http://dmss.stanford.edu/dmstech/CCC001/fob>;
            #     rdf:rest ( <http://dmss.stanford.edu/dmstech/CCC001/fib> <http://dmss.stanford.edu/dmstech/CCC001/iR>
            sequence_subject = RDF::URI('http://dmstech.groups.stanford.edu/ccc001/manifest/NormalSequence')

            writer << RDF::Statement.new({
              :subject   => sequence_subject,
              :predicate => RDF::Resource("#{writer.prefixes[:rdf]}type"),
              :object    => RDF::Resource("#{writer.prefixes[:dms]}sequence")
            })
            
            writer << RDF::Statement.new({
              :subject   => sequence_subject,
              :predicate => RDF::Resource("#{writer.prefixes[:rdf]}type"),
              :object    => RDF::Resource("#{writer.prefixes[:ore]}aggregation")
            })
            
            writer << RDF::Statement.new({
              :subject   => sequence_subject,
              :predicate => RDF::Resource("#{writer.prefixes[:rdf]}type"),
              :object    => RDF::Resource("#{writer.prefixes[:rdf]}List")
            })
            
            writer << RDF::Statement.new({
              :subject   => sequence_subject,
              :predicate => RDF::Resource("#{writer.prefixes[:ore]}aggregates"),
              :object    => RDF::Resource(canvas_subject)
            })
            
            if iteration_count == 1
              writer << RDF::Statement.new({
                :subject   => sequence_subject,
                :predicate => RDF::Resource("#{writer.prefixes[:RDF]}first"),
                :object    => RDF::Resource(canvas_subject)
                })
            else 
              writer << RDF::Statement.new({
                :subject   => sequence_subject,
                :predicate => RDF::Resource("#{writer.prefixes[:RDF]}rest"),
                :object    => RDF::Resource(canvas_subject)
              })
            end
          end        
        end
      end      
    end
  end
end