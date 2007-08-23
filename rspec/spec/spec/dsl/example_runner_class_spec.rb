require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe ExampleRunner, " class" do

      def run(example)
        example.run(@reporter, nil, nil, nil, Object.new)
      end

      before do
        @reporter = stub("reporter", :example_started => nil, :example_finished => nil)
        @example_runner_class = ExampleRunner.dup
      end
      
      it "should report errors in example" do
        error = Exception.new
        example = @example_runner_class.new("example") {raise(error)}
        @reporter.should_receive(:example_finished).with(equal(example), error, "example", false)
        run(example)
      end
    end
  end
end
