module DMS
  module Transformation
    class ImageCollection < DMS::Transformation::Base   
    
      def generate_first_and_rest_manually(highest_sequence_number)
        output = "<http://dmstech.groups.stanford.edu/CCC#{@manuscript.name}/ImageCollection> rdf:first <http://dmstech.groups.stanford.edu/CCC#{@manuscript.name}/images/1>;\n"
        output << "   rdf:rest ( " 
        
        (2..highest_sequence_number).each do |i|
          output << "<http://dmss.groups.stanford.edu/CCC#{manuscript.name}/images/#{i}> "
        end
        
        output << ") ;\n"
      end
          
      def get_image_collection_name(page)
        name = "http://dmstech.groups.stanford.edu/CCC#{manuscript.name}/images/"
        image_path = page.get_no_crop_image.path
        image_path.slice!(".jp2")
        suffix = image_path.split("/")[3]
        suffix.slice!("_R_TC")
        suffix.slice!("_V_TC")
        suffix.slice!("_R_NC")
        suffix.slice!("_V_NC")
        suffix.slice!("_TC")
        suffix.slice!("_NC")
        suffix.slice!("_46")
        name << suffix.split("_")[1]
      end
      
      def serialize
        image_sequence_number = 0
        
        RDF::Writer.open("#{@filename}") do |writer|

           # NAMESPACE PREFIXES
           writer.prefixes = {
             :dc        => RDF::URI('http://purl.org/dc/terms/'),
             :dcmitype  => RDF::URI('http://purl.org/dc/dcmitype/'),
             :dms       => RDF::URI('http://dms.stanford.edu/ns/'),
             :exif      => RDF::URI('http://www.w3.org/2003/12/exif/ns#'),
             :oac       => RDF::URI('http://www.openannotation.org/ns/'),
             :ore       => RDF::URI('http://www.openarchives.org/ore/terms/'),
             :rdf       => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#')
           }    
           
           image_collection_subject = RDF::URI('http://dmstech.groups.stanford.edu/CCC001/ImageCollection')
           
           writer << RDF::Statement.new({
             :subject   => image_collection_subject,
             :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
             :object    => RDF::Resource("#{writer.prefixes[:dms]}ImageCollection")
           })
           
           writer << RDF::Statement.new({
              :subject   => image_collection_subject,
              :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
              :object    => RDF::Resource("#{writer.prefixes[:ore]}Aggregation")
            })
            
            writer << RDF::Statement.new({
               :subject   => image_collection_subject,
               :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
               :object    => RDF::Resource("#{writer.prefixes[:rdf]}List")
             })
             
             # KLUDGE: List support in Ruby's RDF is experimental according to the author.
             writer << RDF::Statement.new({
               :subject   => image_collection_subject,
               :predicate => RDF::Resource('http://replace.me/now#please'),
               :object    => RDF::Resource('_a_seemingly_randomly_string_here_')
             })
                        
            @manuscript.ordered_pages.each do |page|
              next if page.is_skippable?
              
              image_sequence_number = image_sequence_number + 1
              image_sequence_uri = RDF::URI("http://dmss.groups.stanford.edu/CCC#{@manuscript.name}/images/#{image_sequence_number}")
              
              writer << RDF::Statement.new({
                 :subject   => image_collection_subject,
                 :predicate => RDF::Resource("#{writer.prefixes[:ore]}aggregates"),
                 :object    => image_sequence_uri
               })
               
              # NC IMAGES
              writer << RDF::Statement.new({
                :subject   => RDF::URI(page.get_no_crop_image.path),
                :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
                :object    => RDF::Resource("#{writer.prefixes[:dcmitype]}Image")
              })    
              
              writer << RDF::Statement.new({
                :subject   => RDF::URI(page.get_no_crop_image.path),
                :predicate => RDF::Resource("#{writer.prefixes[:dms]}imagetype"),
                :object    => 'NC'
              })
              
              writer << RDF::Statement.new({
                :subject   => RDF::URI(page.get_no_crop_image.path),
                :predicate => RDF::Resource("#{writer.prefixes[:exif]}width"),
                :object    => page.get_no_crop_image.width
              })
              
              writer << RDF::Statement.new({
                :subject   => RDF::URI(page.get_no_crop_image.path),
                :predicate => RDF::Resource("#{writer.prefixes[:exif]}height"),
                :object    => page.get_no_crop_image.height
              })
                  
              # TC IMAGES
              writer << RDF::Statement.new({
                :subject   => RDF::URI(page.get_tight_crop_image.path),
                :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
                :object    => RDF::Resource("#{writer.prefixes[:dcmitype]}Image")
              })    
              
              writer << RDF::Statement.new({
                :subject   => RDF::URI(page.get_tight_crop_image.path),
                :predicate => RDF::Resource("#{writer.prefixes[:dms]}imagetype"),
                :object    => 'TC'
              })
              
              writer << RDF::Statement.new({
                :subject   => RDF::URI(page.get_tight_crop_image.path),
                :predicate => RDF::Resource("#{writer.prefixes[:exif]}width"),
                :object    => page.get_tight_crop_image.width
              })
              
              writer << RDF::Statement.new({
                :subject   => RDF::URI(page.get_tight_crop_image.path),
                :predicate => RDF::Resource("#{writer.prefixes[:exif]}height"),
                :object    => page.get_tight_crop_image.height
              })  
                  
              # CANVASES
              canvas_subject = RDF::URI("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}")
               
              writer << RDF::Statement.new({
                :subject   => canvas_subject,
                :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
                :object    => RDF::Resource("#{writer.prefixes[:dms]}Canvas")
              })
                
              writer << RDF::Statement.new({
                :subject   => canvas_subject,
                :predicate => RDF::Resource("#{writer.prefixes[:exif]}width"),
                :object    => page.get_no_crop_image.width
              })
                  
              writer << RDF::Statement.new({
                :subject   => canvas_subject,
                :predicate => RDF::Resource("#{writer.prefixes[:exif]}height"),
                :object    => page.get_no_crop_image.height
              })
                
              writer << RDF::Statement.new({
                :subject   => canvas_subject,
                :predicate => RDF::Resource("#{writer.prefixes[:dc]}title"),
                :object    => page.label
              })
                 
              # IMAGE CHOICE
                            
              writer << RDF::Statement.new({
                :subject   => RDF::URI("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}.imageChoice"),
                :predicate => RDF::Resource("#{writer.prefixes[:dms]}ImageChoice"),
                :object    => page.get_no_crop_image.path
              })  
              
              writer << RDF::Statement.new({
                :subject   => RDF::URI("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}.imageChoice"),
                :predicate => RDF::Resource("#{writer.prefixes[:dms]}ImageChoice"),
                :object    => page.get_tight_crop_image.path
              })
              
              # IMAGE ANNOTATIONS
              
              writer << RDF::Statement.new({ # <http://dmstech.groups.stanford.edu/CCC001/images/000572> a dms:ImageAnnotation>
                :subject   => image_sequence_uri,
                :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
                :object    => RDF::Resource("#{writer.prefixes[:dms]}ImageAnnotation")
              })
              
              writer << RDF::Statement.new({ # <http://dmstech.groups.stanford.edu/CCC001/images/000572> oac:hasBody <http://dmss.stanford.edu/dmstech/CCC001/283V.imagechoice>
                :subject   => image_sequence_uri,
                :predicate => RDF::Resource("#{writer.prefixes[:oac]}hasBody"), 
                :object    => RDF::URI("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}.imageChoice")
              })
              
              writer << RDF::Statement.new({ # <http://dmstech.groups.stanford.edu/CCC001/images/000572> oac:hasTarget <http://dmss.stanford.edu/dmstech/CCC001/283V>
                :subject   => image_sequence_uri,
                :predicate => RDF::Resource("#{writer.prefixes[:oac]}hasTarget"), 
                :object    => RDF::URI("http://dmss.stanford.edu/dmstech/CCC#{@manuscript.name}/#{page.number}")
              })
            end 
          end
          new_file_contents = ''
          File.open(@filename, "r") do |infile|
            while (line = infile.gets)
              if line.include? 'http://replace.me/now#please'
                new_file_contents << generate_first_and_rest_manually(image_sequence_number)
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