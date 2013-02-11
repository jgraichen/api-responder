require 'test_helper'

describe ApiResponder::Formattable do
  let(:resource)  { Object.new }
  let(:cls)       { Class.new.tap { |c| c.send :include, ApiResponder::Formattable }}
  let(:decorator) { cls.new }

  describe "#api_formats" do
    it "should have active json as default" do
      assert_equal [ :json ], cls.api_formats
    end

    it "should return list of active formats" do
      cls.api_formats :xml
      assert_equal [ :json, :xml ], cls.api_formats
    end

    it "should have as_json method that delegates to as_api" do
      decorator.expects(:as_api).with({:format => :json}).returns(resource)
      resource.expects(:as_json).with({}).returns({})
      decorator.as_json({})
    end

    it "should create to_format method that delegates to as_api" do
      cls.api_formats :xml
      decorator.expects(:as_api).with({:format => :xml}).returns(resource)
      resource.expects(:to_xml).with({}).returns("")

      decorator.to_xml({})
    end
  end

  describe "#to_format" do
    it "should merge options" do
      cls.api_formats :xml
      decorator.expects(:as_api).with({:format => :xml, :include_root => true}).returns(resource)
      resource.expects(:to_xml).with({:include_root => true}).returns("")

      decorator.to_xml({:include_root => true})
    end
  end

  describe "#as_api" do
    it "should delegate to to_api_v{api_version}" do
      decorator.expects(:as_api_v2).with({:format => :json}).returns({})

      decorator.as_api({:format => :json, :api_version => 2})
    end

    it "should use version 1 if no version is given" do
      decorator.expects(:as_api_v1).with({:format => :json}).returns({})

      decorator.as_api({:format => :json})
    end

    it "should raise exception if no version helper exists" do
      assert_raises ApiResponder::Formattable::UnsupportedVersion do
        decorator.as_api({:format => :json, :api_version => 4})
      end
    end
  end
end

