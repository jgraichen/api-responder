require 'spec_helper'

describe ApiResponder::Formattable do
  let(:resource)  { Object.new }
  let(:cls)       { Class.new.tap { |c| c.send :include, ApiResponder::Formattable }}
  let(:decorator) { cls.new }

  context "#api_formats" do
    it "should have active json as default" do
      cls.api_formats.should == [ :json ]
    end

    it "should return list of active formats" do
      cls.api_formats :xml
      cls.api_formats.should == [ :json, :xml ]
    end

    it "should have as_json method that delegates to as_api" do
      decorator.should_receive(:as_api).with({:format => :json}).and_return(resource)
      resource.should_receive(:as_json).with({}).and_return({})
      decorator.as_json({})
    end

    it "should create to_format method that delegates to as_api" do
      cls.api_formats :xml
      decorator.should_receive(:as_api).with({:format => :xml}).and_return(resource)
      resource.should_receive(:to_xml).with({}).and_return("")

      decorator.to_xml({})
    end
  end

  context "#to_format" do
    it "should merge options" do
      cls.api_formats :xml
      decorator.should_receive(:as_api).with({:format => :xml, :include_root => true}).and_return(resource)
      resource.should_receive(:to_xml).with({:include_root => true}).and_return("")

      decorator.to_xml({:include_root => true})
    end
  end

  context "#as_api" do
    it "should delegate to to_api_v{api_version}" do
      decorator.should_receive(:as_api_v2).with({:format => :json}).and_return({})

      decorator.as_api({:format => :json, :api_version => 2})
    end

    it "should use version 1 if no version is given" do
      decorator.should_receive(:as_api_v1).with({:format => :json}).and_return({})

      decorator.as_api({:format => :json})
    end

    it "should raise exception if no version helper exists" do
      expect { decorator.as_api({:format => :json, :api_version => 4}) }
        .to raise_error(ApiResponder::Formattable::UnsupportedVersion)
    end
  end
end

