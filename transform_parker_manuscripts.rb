#!/usr/bin/env ruby

require 'lib/dms'

DATA_DIRECTORY    = "data"  # change this to 'data' for the complete collection
INPUT_DIRECTORY   = "#{DATA_DIRECTORY}/input/xml" 
OUTPUT_DIRECTORY  = "#{DATA_DIRECTORY}/output/n3" 

puts "Examining #{INPUT_DIRECTORY} for Parker XML configuration files\n"

Dir.glob("#{INPUT_DIRECTORY}/3*.xml") { |file|
  puts "Processing #{file}" if DMS::debug  
  manuscript = DMS::Manuscript.new(file)
  puts "\nTransforming manuscript #{manuscript.name}"    
  puts "  Manuscript: #{manuscript.inspect}" if DMS::debug
  
  # For now, we're skipping manuscripts with flaps, folds, bookmarks or spreads
  if manuscript.has_flap? || manuscript.has_fold? || manuscript.has_bookmark? || manuscript.has_spread?
    puts "  This manuscript cannot be transformed; it has one or more flaps, folds, bookmarks and/or spreads"
    next
  end
  
  # ___  ___            _  __          _   
  # |  \/  |           (_)/ _|        | |  
  # | .  . | __ _ _ __  _| |_ ___  ___| |_ 
  # | |\/| |/ _` | '_ \| |  _/ _ \/ __| __|
  # | |  | | (_| | | | | | ||  __/\__ \ |_ 
  # \_|  |_/\__,_|_| |_|_|_| \___||___/\__|

  puts "  Generating Manifest file"
  manifest_file = "#{OUTPUT_DIRECTORY}/Manifest#{manuscript.name}.n3"
  manifest = DMS::Transformation::Manifest.new(manuscript, manifest_file)

  #  _   _                            _ _____                                      
  # | \ | |                          | /  ___|                                     
  # |  \| | ___  _ __ _ __ ___   __ _| \ `--.  ___  __ _ _   _  ___ _ __   ___ ___ 
  # | . ` |/ _ \| '__| '_ ` _ \ / _` | |`--. \/ _ \/ _` | | | |/ _ \ '_ \ / __/ _ \
  # | |\  | (_) | |  | | | | | | (_| | /\__/ /  __/ (_| | |_| |  __/ | | | (_|  __/
  # \_| \_/\___/|_|  |_| |_| |_|\__,_|_\____/ \___|\__, |\__,_|\___|_| |_|\___\___|
  #                                                   | |                          
  #                                                   |_|
  
  puts "  Generating NormalSequence file"
  normal_sequence_file = "#{OUTPUT_DIRECTORY}/NormalSequence#{manuscript.name}.n3"
  normal_sequence = DMS::Transformation::NormalSequence.new(manuscript, normal_sequence_file)

  #  _____                           _____       _ _           _   _             
  # |_   _|                         /  __ \     | | |         | | (_)            
  #   | | _ __ ___   __ _  __ _  ___| /  \/ ___ | | | ___  ___| |_ _  ___  _ __  
  #   | || '_ ` _ \ / _` |/ _` |/ _ \ |    / _ \| | |/ _ \/ __| __| |/ _ \| '_ \ 
  #  _| || | | | | | (_| | (_| |  __/ \__/\ (_) | | |  __/ (__| |_| | (_) | | | |
  #  \___/_| |_| |_|\__,_|\__, |\___|\____/\___/|_|_|\___|\___|\__|_|\___/|_| |_|
  #                        __/ |                                                 
  #                       |___/  
  
  puts "  Generating ImageCollection file"
  image_collection_file = "#{OUTPUT_DIRECTORY}/ImageCollection#{manuscript.name}.n3"
  image_collection = DMS::Transformation::ImageCollection.new(manuscript, image_collection_file)
  GC.start
}