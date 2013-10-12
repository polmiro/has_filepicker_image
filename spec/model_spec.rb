require 'spec_helper'

describe TestModel do

  before(:each) do
    clean_database
    allow_message_expectations_on_nil
    ::Rails.application.stub_chain(:config, :has_filepicker_image, :asset_host).and_return(nil)
  end

  let(:model) { TestModel.new(image_url: 'http://filepicker.io/image') }

  describe "#image" do
    context "when no url" do
      it "returns nil" do
        model.image_url = nil
        model.image.should be_nil
      end
    end

    context "when CDN configured" do
      it "returns nil" do
        cdn = 'cdn.net'
        ::Rails.application.stub_chain(:config, :has_filepicker_image, :asset_host).and_return(cdn)
        model.image.should == 'http://cdn.net/image'
      end
    end

    context "when called without arguments" do
      it "returns the original url" do
        model.image.should == 'http://filepicker.io/image'
      end
    end

    context "when called with options" do
      it "returns the url with the options" do
        model.image(w: 1, h: 2).should == 'http://filepicker.io/image/convert?w=1&h=2&fit=max&dl=false'
      end
    end

    context "when called with a style" do
      it "returns the url with the dimensions of the style" do
        model.image(:small).should == 'http://filepicker.io/image/convert?w=50&h=100&fit=max&dl=false'
      end
    end

    context "when called with a style and options" do
      it "returns the url with the dimensions of the style" do
        model.image(:small, fit: 'crop').should == 'http://filepicker.io/image/convert?fit=crop&w=50&h=100&dl=false'
      end
    end
  end

end