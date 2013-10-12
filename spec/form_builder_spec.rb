require 'spec_helper'

describe HasFilepickerImage::FormBuilderHelper do
  class FormBuilder < ActionView::Helpers::FormBuilder
    include HasFilepickerImage::FormBuilderHelper
  end

  describe "#filepicker_image_field" do
    before do
      @configuration = HasFilepickerImage::Configuration.new
      @configuration.defaults = {
        :pick_button_html => 'Pick',
        :delete_button_html => 'Remove'
      }
      allow_message_expectations_on_nil
      ::Rails.application.stub_chain(:config, :has_filepicker_image).and_return(@configuration)
    end

    let(:model)   { TestModel.new }
    let(:builder) { FormBuilder.new(:test_model, model, ActionView::Base.new, {}, proc {}) }

    it "should add a filepicker_image_field method" do
      builder.should respond_to(:filepicker_image_field)
    end

    it "returns the filepicker input field" do
      builder.filepicker_image_field(:image_url).should ==
      "<div class=\"filepicker-button\">" +
        "<a data-action=\"pickImage\" href=\"#\" style=\"\">Pick</a>" +
        "<a href=\"#\" data-action=\"removeImage\" style=\"display:none;\">Remove</a>" +
      "</div>" +
      "<div class=\"filepicker-image\" style=\"display:none;\"></div>" +
      "<input id=\"test_model_image_url\" name=\"test_model[image_url]\" type=\"hidden\" />"
    end

    it "returns the filepicker input with preview" do
      model.image_url = 'http://filepicker.io/images/1'
      builder.filepicker_image_field(:image_url).should ==
      "<div class=\"filepicker-button\">" +
        "<a data-action=\"pickImage\" href=\"#\" style=\"display:none;\">Pick</a>" +
        "<a href=\"#\" data-action=\"removeImage\" style=\"\">Remove</a>" +
      "</div>" +
      "<div class=\"filepicker-image\" style=\"\"><img alt=\"image_url thumbnail\" src=\"http://filepicker.io/images/1/convert?w=260&amp;h=180\" /></div>" +
      "<input id=\"test_model_image_url\" name=\"test_model[image_url]\" type=\"hidden\" value=\"http://filepicker.io/images/1\" />"
    end

    it "returns the filepicker input with defaults options" do
      @configuration.defaults = @configuration.defaults.deep_merge(
        :html_options => { :'data-fp-debug' => true }
      )

      builder.filepicker_image_field(:image_url).should ==
      "<div class=\"filepicker-button\">" +
        "<a data-action=\"pickImage\" data-fp-debug=\"true\" href=\"#\" style=\"\">Pick</a>" +
        "<a href=\"#\" data-action=\"removeImage\" style=\"display:none;\">Remove</a>" +
      "</div>" +
      "<div class=\"filepicker-image\" style=\"display:none;\"></div>" +
      "<input id=\"test_model_image_url\" name=\"test_model[image_url]\" type=\"hidden\" />"
    end

    it "returns the filepicker input with custom options" do
      @configuration.defaults = {
        :pick_button_html => 'Add Photo',
        :delete_button_html => 'Remove Photo'
      }

      builder.filepicker_image_field(:image_url).should ==
      "<div class=\"filepicker-button\">" +
        "<a data-action=\"pickImage\" href=\"#\" style=\"\">Add Photo</a>" +
        "<a href=\"#\" data-action=\"removeImage\" style=\"display:none;\">Remove Photo</a>" +
      "</div>" +
      "<div class=\"filepicker-image\" style=\"display:none;\"></div>" +
      "<input id=\"test_model_image_url\" name=\"test_model[image_url]\" type=\"hidden\" />"
    end


    it "returns input with a different config" do
      @configuration.add_config(
        :picture_config,
        :pick_button_html => 'Add Picture',
        :delete_button_html => 'Remove Picture'
      )

      builder.filepicker_image_field(:image_url, :picture_config).should ==
      "<div class=\"filepicker-button\">" +
        "<a data-action=\"pickImage\" href=\"#\" style=\"\">Add Picture</a>" +
        "<a href=\"#\" data-action=\"removeImage\" style=\"display:none;\">Remove Picture</a>" +
      "</div>" +
      "<div class=\"filepicker-image\" style=\"display:none;\"></div>" +
      "<input id=\"test_model_image_url\" name=\"test_model[image_url]\" type=\"hidden\" />"
    end

  end
end