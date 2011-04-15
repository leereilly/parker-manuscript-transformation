module DMS
  module Transformation
    class NormalSequence < DMS::Transformation::Base      
      # KLUDGE: This CANNOT appear at the end... ';' vs. '.' issue.
      # rdf:first <http://dmss.stanford.edu/dmstech/CCC001/fob>;
      # rdf:rest ( <http://dmss.stanford.edu/dmstech/CCC001/fib> <http://dmss.stanford.edu/dmstech/CCC001/bob> );
      def generate_first_and_rest_manually
        ordered_pages = @manuscript.ordered_pages
        output = "#{RDF::URI('<http://dmstech.groups.stanford.edu/ccc001/manifest/NormalSequence>')}    rdf:first <http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{ordered_pages[0].number}>;\n"
        ordered_pages.shift
        output << "   rdf:rest ( " 
        ordered_pages.each do |page|
          output << "<http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}> "
        end
        output << ") ;\n"
      end
      
      def serialize()
        RDF::Writer.open("#{@filename}") do |writer|
          sequence_subject = RDF::URI('http://dmstech.groups.stanford.edu/ccc001/manifest/NormalSequence')
          
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
              :object    => "CCC#{@manuscript.name} #{page.label}"
            })

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
            
            # KLUDGE: List support in Ruby's RDF is experimental according to the author.
            writer << RDF::Statement.new({
              :subject   => sequence_subject,
              :predicate => RDF::Resource('http://replace.me/now#please'),
              :object    => RDF::Resource('_a_seemingly_randomly_string_here_')
            })
          end  
        end
        
       # KLUDGE - String replace to generate first/rest
       new_file_contents = ''
       replacement_string = "<http://dmstech.groups.stanford.edu/ccc#{@manuscript.name}/manifest/NormalSequence> <http://replace.me/now#please> <_a_seemingly_randomly_string_here_>;\n"
       
       File.open(@filename, "r") do |infile|
         while (line = infile.gets)
           if line.include? 'http://replace.me/now#please'
             new_file_contents << generate_first_and_rest_manually
           else
             new_file_contents << line
           end
         end
       end
       File.open(@filename, 'w') {|f| f.write(new_file_contents) }
      end    
    end
  end
end