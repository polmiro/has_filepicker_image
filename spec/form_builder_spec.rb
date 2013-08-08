require 'spec_helper'

describe HasFilepickerImage::FormBuilderHelper do
  class FormBuilder < ActionView::Helpers::FormBuilder
    include HasFilepickerImage::FormBuilderHelper
  end

  describe "#filepicker_image_field" do
    before do
      @configuration = HasFilepickerImage::Configuration.new
      @configuration.stub(:defaults).and_return({})
      allow_message_expectations_on_nil
      ::Rails.application.stub_chain("config.has_filepicker_image").and_return(@configuration)
      ::Rails.env == 'production'
    end

    let(:model)   { TestModel.new }

    let(:builder) do
      FormBuilder.new(:test_model, model, ActionView::Base.new, {}, proc {})
    end

    let(:filepicker_image_field) do
      builder.filepicker_image_field(:image_url)
    end

    it {  builder.should respond_to(:filepicker_image_field) }

    it "returns the filepicker input field" do
      filepicker_image_field.should ==
      "<div class='filepicker-image'></div><a data-action=\"pickImage\" href=\"#\"></a><input id=\"test_model_image_url\" name=\"test_model[image_url]\" type=\"hidden\" />"
    end

    it "returns input with defaults options" do
      @configuration.stub(:defaults).and_return(:html_options => { :'data-fp-debug' => true })
      filepicker_image_field.should ==
      "<div class='filepicker-image'></div><a data-action=\"pickImage\" data-fp-debug=\"true\" href=\"#\"></a><input id=\"test_model_image_url\" name=\"test_model[image_url]\" type=\"hidden\" />"
    end

    it "returns the filepicker input with value and an the image tag when model has url has value" do
      model.image_url = 'http://filepicker.io/images/1'
      filepicker_image_field.should ==
      "<div class='filepicker-image'><img alt=\"image_url thumbnail\" src=\"http://filepicker.io/images/1/convert?w=260&amp;h=180\" /></div><input id=\"test_model_image_url\" name=\"test_model[image_url]\" type=\"hidden\" value=\"http://filepicker.io/images/1\" />"
    end

  end
end