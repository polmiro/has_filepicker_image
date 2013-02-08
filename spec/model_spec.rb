require 'spec_helper'

describe TestModel do

  before(:each) do
    clean_database
  end

  let(:model) { TestModel.new(image_url: 'http://filepicker.io/image') }

  describe "#image_url" do
    context "when no url" do
      it "returns nil" do
        model.image_url = nil
        model.image_url.should be_nil
      end
    end

    context "when called without arguments" do
      it "returns the original url" do
        model.image_url.should == 'http://filepicker.io/image'
      end
    end

    context "when called with options" do
      it "returns the url with the options" do
        model.image_url(w: 1, h: 2).should == 'http://filepicker.io/image/convert?w=1&h=2&fit=max'
      end
    end

    context "when called with a style" do
      it "returns the url with the dimensions of the style" do
        model.image_url(:small).should == 'http://filepicker.io/image/convert?w=50&h=100&fit=max'
      end
    end

    context "when called with a style and options" do
      it "returns the url with the dimensions of the style" do
        model.image_url(:small, fit: 'crop').should == 'http://filepicker.io/image/convert?fit=crop&w=50&h=100'
      end
    end
  end

end