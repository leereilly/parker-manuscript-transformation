module DMS
  module Transformation
    class NormalSequence
      attr_accessor :manuscript, :filename

      def initialize(manuscript = nil, filename = nil)
        @manuscript = manuscript
        @filename = filename
        self.serialize
      end
      
      # KLUDGE: This CANNOT appear at the end... ';' vs. '.' issue.
      # rdf:first <http://dmss.stanford.edu/dmstech/CCC001/fob>;
      # rdf:rest ( <http://dmss.stanford.edu/dmstech/CCC001/fib> <http://dmss.stanford.edu/dmstech/CCC001/bob> );
      def generate_first_and_rest_manually
        output = "    rdf:first <http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{@manuscript.ordered_pages[0].number}>;\n"
        output << "    rdf:rest ( " 
        @manuscript.ordered_pages.each do |page|
          output << "<http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}> "
        end
        output << ") ."
      end
      
      def serialize()
        rest_statements = Array.new
        RDF::Writer.open("#{@filename}") do |writer|
          sequence_subject = RDF::URI('http://dmstech.groups.stanford.edu/ccc001/manifest/NormalSequence')
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
              rest_statements << RDF::Statement.new({
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