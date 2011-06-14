$:.unshift File.join(File.dirname(__FILE__),'lib')

require 'net/http'
require 'sinatra'
require 'json'
require 'uri'
require 'dms'

# Input directory
XML_DIR = "data/input/xml"

# Output directories / caches
JSON_DIR = "data/output/json"
N3_DIR = "data/output/n3"

DEBUG = true

def get_manuscript_files
  manuscripts_filenames = Array.new
  
  Dir.glob("#{XML_DIR}/*.xml") { |file|
    manuscripts_filenames << File.basename(file, ".xml")
  }
  
  return manuscripts_filenames
end

get '/?' do
  erb :index
end

get '/manuscript' do
  content_type :json
  manuscripts = get_manuscript_files
  manuscripts.to_json
end

get '/manuscript/:manuscript/manifest.n3' do
  manuscript = DMS::Manuscript.new(XML_DIR + "/" + params[:manuscript] + ".xml")
  manifest_file = N3_DIR + "/" + params[:manuscript] + ".n3"
  manifest = DMS::Transformation::Manifest.new(manuscript, manifest_file)
  send_file(manifest_file)
end

get '/manuscript/:manuscript/normal_sequence.n3' do
    manuscript = DMS::Manuscript.new(XML_DIR + "/" + params[:manuscript] + ".xml")
    normal_sequence_file = N3_DIR + "/" + params[:manuscript] + ".n3"
    manifest = DMS::Transformation::NormalSequence.new(manuscript, normal_sequence_file)
    send_file(normal_sequence_file)
end

get '/manuscript/:manuscript/image_collection.n3' do
    manuscript = DMS::Manuscript.new(XML_DIR + "/" + params[:manuscript] + ".xml")
    image_collection_file = N3_DIR + "/" + params[:manuscript] + ".n3"
    manifest = DMS::Transformation::ImageCollection.new(manuscript, image_collection_file)
    send_file(image_collection_file)
end

get '/manuscript/:manuscript/?' do
  content_type :json
  manuscript = DMS::Manuscript.new(XML_DIR + "/" + params[:manuscript] + ".xml")
  manuscript.to_json
end
