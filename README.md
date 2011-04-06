# PARKER MANUSCRIPT TRANSFORMATION

## Summary

This is a one-time use script for transforming Parker XML configuration scripts used on <http://parker.stanford.edu> into N3 format.

## Usage

To transform the XML files in data/input/xml to N3 in data/output/n3 simply run the following:

    ./transform_parker_manuscripts.rb

__NB:__ The script is set to transform the files in test_data by default. 

## Dependencies

* [ruby 1.8.7](http://www.ruby-lang.org "ruby 1.8.7")
* [rubygems 1.3.5 ](http://rubygems.org "rubygems 1.3.5 )
* [rdf 0.3.1](https://github.com/bendiken/rdf "rdf 0.3.1")
* [rdf::n3 0.3.1.1](https://github.com/gkellogg/rdf-n3 "rdf::n3 0.3.1.1")
* [nokogiri 1.4.4](http://nokogiri.org "nokogiri 1.4.4")

## Known Issues / Bugs
* RDF::List support is "experimental"
* Transformation fails for pages that have folds, flaps or bookmarks
* Transformation fails for pages that are spreads
* The DMS data model is ever-evolving

![Bugs](http://i.imgur.com/K8vsw.gif "Bugs")


