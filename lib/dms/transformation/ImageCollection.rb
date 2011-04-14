module DMS
  module Transformation
    class ImageCollection < DMS::Transformation::Base   
      
      # http://dmstech.groups.stanford.edu/CCC001/images/000100
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
        # prefix dc: <http://purl.org/dc/elements/1.1/> .
        # @prefix dcmitype: <http://purl.org/dc/dcmitype/> .
        # @prefix dms: <http://dms.stanford.edu/ns/> .
        # @prefix exif: <http://www.w3.org/2003/12/exif/ns#> .
        # @prefix oac: <http://www.openannotation.org/ns/> .
        # @prefix ore: <http://www.openarchives.org/ore/terms/> .
        # @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
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
            
            image_sequence_number = 0
            
            @manuscript.ordered_pages.each do |page|
              next if page.is_skippable?
              
              image_sequence_number = image_sequence_number + 1
              image_sequence_uri = RDF::URI("http://dmss.groups.stanford.edu/CCC#{@manuscript.name}/images/#{image_sequence_number}")
              
              writer << RDF::Statement.new({
                 :subject   => image_collection_subject,
                 :predicate => RDF::Resource("#{writer.prefixes[:ore]}aggregates"),
                 :object    => image_sequence_uri
               })
               
               #TODO: RDF first/rest
              
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
                 
              # IMAGE CHOCE
              writer << RDF::Statement.new({
                :subject   => "#{canvas_subject}.imageChoice",
                :predicate => RDF::Resource("#{writer.prefixes[:dms]}ImageChoice"),
                :object    => page.get_no_crop_image.path
              })  
              
              writer << RDF::Statement.new({
                :subject   => "#{canvas_subject}.imageChoice",
                :predicate => RDF::Resource("#{writer.prefixes[:dms]}ImageChoice"),
                :object    => page.get_tight_crop_image.path
              })
              
              # IMAGE ANNOTATION
              # <http://dmstech.groups.stanford.edu/CCC001/images/000572> a dms:ImageAnnotation;
              #     oac:hasBody <http://dmss.stanford.edu/dmstech/CCC001/283V.imagechoice>;
              #     oac:hasTarget <http://dmss.stanford.edu/dmstech/CCC001/283V> .
              writer << RDF::Statement.new({ # <http://dmstech.groups.stanford.edu/CCC001/images/000572> a dms:ImageAnnotation>
                :subject   => image_sequence_uri,
                :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
                :object    => RDF::Resource("#{writer.prefixes[:dms]}ImageAnnotation")
              })
              
              writer << RDF::Statement.new({ # <http://dmstech.groups.stanford.edu/CCC001/images/000572> oac:hasBody <http://dmss.stanford.edu/dmstech/CCC001/283V.imagechoice>
                :subject   => image_sequence_uri,
                :predicate => RDF::Resource("#{writer.prefixes[:oac]}hasBody"), 
                :object    => ''
              })
              
              writer << RDF::Statement.new({ # <http://dmstech.groups.stanford.edu/CCC001/images/000572> oac:hasTarget <http://dmss.stanford.edu/dmstech/CCC001/283V>
                :subject   => image_sequence_uri,
                :predicate => RDF::Resource("#{writer.prefixes[:oac]}hasTarget"), 
                :object    => ''
              })
            end 
          end
        end
      end
    end
  end