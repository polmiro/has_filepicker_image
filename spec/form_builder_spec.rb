require 'spec_helper'

describe HasFilepickerImage::FormBuilderMixin do
  class FormBuilder < ActionView::Helpers::FormBuilder
    include HasFilepickerImage::FormBuilderMixin
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
      "<input id=\"test_model_image_url\" name=\"test_model[image_url]\" size=\"30\" type=\"filepicker\" />"
    end

    it "returns input with defaults options" do
      @configuration.stub(:defaults).and_return(:'data-fp-debug' => true)
      filepicker_image_field.should ==
      "<input data-fp-debug=\"true\" id=\"test_model_image_url\" name=\"test_model[image_url]\" size=\"30\" type=\"filepicker\" />"
    end

    context "when model has url has value" do
      before { model.image_url = 'http://filepicker.io/images/1' }

      context "when not replaceable" do
        before { ::Rails.application.config.has_filepicker_image.replaceable = false }

        it "returns the filepicker input with value" do
          filepicker_image_field.should ==
          "<input id=\"test_model_image_url\" name=\"test_model[image_url]\" size=\"30\" type=\"filepicker\" value=\"#{model.image_url}\" />"
        end
      end

      context "when replaceable" do
        before { ::Rails.application.config.has_filepicker_image.replaceable = true }

        it "returns the filepicker input with value" do
          filepicker_image_field.should ==
          "<input data-fp-button-text=\"Replace\" id=\"test_model_image_url\" name=\"test_model[image_url]\" size=\"30\" type=\"filepicker\" value=\"#{model.image_url}\" />" +
          "<div class='filepicker-image'><img alt=\"image_url thumbnail\" src=\"http://filepicker.io/images/1/convert?w=260&amp;h=180\" /></div>".html_safe
        end
      end
    end

  end
end