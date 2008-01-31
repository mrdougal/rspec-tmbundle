require "rubygems"
require 'autotest'
dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"
require File.expand_path("#{dir}/../lib/autotest/rspec")

module Spec
  module Matchers
    class AutotestMappingMatcher
      def initialize(specs)
        @specs = specs
      end
  
      def to(file)
        @file = file
        self
      end
  
      def matches?(autotest)
        @autotest = prepare autotest
        @actual = autotest.test_files_for(@file)
        @actual == @specs
      end
  
      def failure_message
        "expected #{@autotest.class} to map #{@specs.inspect} to #{@file.inspect}\ngot #{@actual.inspect}"
      end
  
      private
      def prepare autotest
        stub_found_files autotest
        stub_find_order autotest
        autotest
      end
  
      def stub_found_files autotest
        mtime = Time.at(0)
        found_files = Hash.new {|h,k| h[k] = mtime}
        @specs.each {|s| found_files[s]}
        autotest.stub!(:find_files).and_return(found_files)
      end

      def stub_find_order autotest
        find_order = @specs.dup << @file
        autotest.instance_eval { @find_order = find_order }
      end

    end
    
    def map_specs(specs)
      AutotestMappingMatcher.new(specs)
    end
    
  end
end