module DMS
  module Transformation
    class Manifest < DMS::Transformation::Base   
      attr_accessor :manuscript, :filename

      def serialize
         RDF::Writer.open("#{@filename}") do |writer|
    
            # NAMESPACE PREFIXES
            writer.prefixes = {
              :dms    => RDF::URI('http://dms.stanford.edu/ns/'),
              :ore    => RDF::URI('http://www.openarchives.org/ore/terms/'),
              :rdf    => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#')
            }
            
            # MANIFEST
            manifest_subject = RDF::URI("#{writer.prefixes[:dms]}Manifest")
            
            writer << RDF::Statement.new({
              :subject   => manifest_subject,
              :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
              :object    => RDF::Resource("#{writer.prefixes[:ore]}Aggregation")
            })
            
            writer << RDF::Statement.new({
              :subject   => manifest_subject,
              :predicate => RDF::Resource("#{writer.prefixes[:ore]}aggregates"), 
              :object    => RDF::Resource("#{writer.prefixes[:dms]}ImageCollection")
            })
            
            writer << RDF::Statement.new({
              :subject   => manifest_subject,
              :predicate => RDF::Resource("#{writer.prefixes[:ore]}aggregates"), 
              :object    => RDF::Resource("#{writer.prefixes[:dms]}NormalSequence")
            })
            
            # IMAGECOLLECTION
            image_collection_subject = RDF::URI("#{writer.prefixes[:dms]}ImageCollection")
            
            writer << RDF::Statement.new({
              :subject   => image_collection_subject,
              :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
              :object    => RDF::Resource("#{writer.prefixes[:ore]}Aggregation")
            })
            
            writer << RDF::Statement.new({
              :subject   => image_collection_subject,
              :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
              :object    => RDF::Resource("#{writer.prefixes[:ore]}List")
            })
            
            # NORMALSEQUENCE
            normal_sequence_subject = RDF::URI("#{writer.prefixes[:dms]}NormalSequence")
            
            writer << RDF::Statement.new({
              :subject   => normal_sequence_subject,
              :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
              :object    => RDF::Resource("#{writer.prefixes[:ore]}Aggregation")
            })
            
            writer << RDF::Statement.new({
              :subject   => normal_sequence_subject,
              :predicate => RDF::URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'), 
              :object    => RDF::Resource("#{writer.prefixes[:ore]}List")
            })
          end
      end
    end
  end
end