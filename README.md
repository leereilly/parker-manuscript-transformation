# PARKER MANUSCRIPT TRANSFORMATION

## Summary

This is a one-time use script for transforming Parker XML configuration scripts used on <http://parker.stanford.edu> into N3 format.

## Usage

To transform the XML files in data/input/xml to N3 in data/output/n3 simply run the following:

    ./transform_parker_manuscripts.rb

__NB:__ The script is set to transform the files in test_data by default. 

## Dependencies

* [ruby 1.8.7](http://example.com/ "ruby 1.8.7")
* [rubygems 1.3.5 ](http://example.com/ "rubygems 1.3.5 )
* [rdf 0.3.1](http://example.com/ "rdf 0.3.1")
* [rdf::n3 0.3.1.1](http://example.com/ "rdf::n3 0.3.1.1")

## Known Issues
* RDF::List support is "experimental"
* Transformation fails for pages that have folds, flaps or bookmarks
* Transformation fails for pages that are spreads
* The DMS data model is ever-evolving

![Bugs](http://www.animalshelter.org.uk/images/bug_animated.gif "Bugs")


