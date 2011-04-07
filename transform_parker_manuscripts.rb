#!/usr/bin/env ruby

require 'lib/dms'

DATA_DIRECTORY    = "test_data"  # change this to 'data' for the complete collection
INPUT_DIRECTORY   = "#{DATA_DIRECTORY}/input/xml" 
OUTPUT_DIRECTORY  = "#{DATA_DIRECTORY}/input/n3" 

parker_manuscripts = Array.new

puts "Examining #{INPUT_DIRECTORY} for Parker XML configuration file\n"

Dir.glob("#{INPUT_DIRECTORY}/*.xml") { |file|
  puts "Processing #{file}" if DMS::debug  
  manuscript = DMS::Manuscript.new(file)
  parker_manuscripts << manuscript
}

parker_manuscripts.each do |manuscript|
  puts "\nTransforming manuscript #{manuscript.name}"    
  puts "  Manuscript: #{manuscript.inspect}" if DMS::debug
  
  # For now, we're skipping manuscripts with flaps, folds, bookmarks or spreads
  if manuscript.has_flap? || manuscript.has_fold? || manuscript.has_bookmark? || manuscript.has_spread?
    puts "  This manuscript cannot be transformed; it has one or more flaps, fold, bookmarks and/or spreads"
    next
  end
  
  puts "  Generating Manifest file"
  
  # ___  ___            _  __          _   
  # |  \/  |           (_)/ _|        | |  
  # | .  . | __ _ _ __  _| |_ ___  ___| |_ 
  # | |\/| |/ _` | '_ \| |  _/ _ \/ __| __|
  # | |  | | (_| | | | | | ||  __/\__ \ |_ 
  # \_|  |_/\__,_|_| |_|_|_| \___||___/\__|

  puts "  Generating NormalSequence file"

  #  _   _                            _ _____                                      
  # | \ | |                          | /  ___|                                     
  # |  \| | ___  _ __ _ __ ___   __ _| \ `--.  ___  __ _ _   _  ___ _ __   ___ ___ 
  # | . ` |/ _ \| '__| '_ ` _ \ / _` | |`--. \/ _ \/ _` | | | |/ _ \ '_ \ / __/ _ \
  # | |\  | (_) | |  | | | | | | (_| | /\__/ /  __/ (_| | |_| |  __/ | | | (_|  __/
  # \_| \_/\___/|_|  |_| |_| |_|\__,_|_\____/ \___|\__, |\__,_|\___|_| |_|\___\___|
  #                                                   | |                          
  #                                                   |_|

  puts "  Generating ImageCollection file"

  #  _____                           _____       _ _           _   _             
  # |_   _|                         /  __ \     | | |         | | (_)            
  #   | | _ __ ___   __ _  __ _  ___| /  \/ ___ | | | ___  ___| |_ _  ___  _ __  
  #   | || '_ ` _ \ / _` |/ _` |/ _ \ |    / _ \| | |/ _ \/ __| __| |/ _ \| '_ \ 
  #  _| || | | | | | (_| | (_| |  __/ \__/\ (_) | | |  __/ (__| |_| | (_) | | | |
  #  \___/_| |_| |_|\__,_|\__, |\___|\____/\___/|_|_|\___|\___|\__|_|\___/|_| |_|
  #                        __/ |                                                 
  #                       |___/  
end