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
    let(:builder) do
      args = [:test_model, model, ActionView::Base.new, {}]
      args << proc {} if Rails::VERSION::MAJOR < 4
      FormBuilder.new(*args)
    end

    let(:rendered) { builder.filepicker_image_field(:image_url) }

    it "displays the buttons" do
      rendered.should have_tag 'div', :with => { :class => 'filepicker-button' } do
        with_tag "a", :text => "Pick"
        with_tag "a", :text => "Remove"
      end
    end

    it "displays the image div" do
      rendered.should have_tag "div", :with => { :class => 'filepicker-image' }
    end

    it "displays the hidden input" do
      rendered.should have_tag "input", :with => {
        :id => "test_model_image_url",
        :name => "test_model[image_url]",
        :type => "hidden"
      }
    end

    it "displays customized buttons text" do
      @configuration.defaults = {
        :pick_button_html => 'Add Photo',
        :delete_button_html => 'Remove Photo'
      }

      rendered.should have_tag 'div' do
        with_tag "a", :text => "Add Photo"
        with_tag "a", :text => "Remove Photo"
      end
    end

    it "displays the filepicker input with custom defaults options" do
      @configuration.defaults = @configuration.defaults.deep_merge(
        :html_options => { :'data-fp-debug' => true }
      )

      rendered.should have_tag 'div' do
        with_tag "a", :with => { :'data-fp-debug' => "true" }
      end
    end

    it "displays options from a custom config" do
      @configuration.add_config(
        :picture_config,
        :pick_button_html => 'Add Picture',
        :delete_button_html => 'Remove Picture'
      )
      rendered = builder.filepicker_image_field(:image_url, :picture_config)
      rendered.should have_tag 'div' do
        with_tag "a", :text => "Add Picture"
        with_tag "a", :text => "Remove Picture"
      end
    end

    context "when empty value" do
      it "displays buttons showing the pick one" do
        rendered.should have_tag 'div', :with => { :class => 'filepicker-button' } do
          with_tag "a", :text => "Pick", :with => { :'data-action' => "pickImage", :style => "" }
          with_tag "a", :text => "Remove", :with => { :'data-action' => "removeImage", :style => "display:none;" }
        end
      end

      it "does NOT display image previews" do
        rendered.should have_tag "div", :with => { :class => 'filepicker-image', :style => 'display:none;' } do
          without_tag "img"
        end
      end

      it "displays the hidden input" do
        rendered.should have_tag "input", :with => {
          :id => "test_model_image_url",
          :name => "test_model[image_url]",
          :type => "hidden"
        }
      end
    end


    context "when value present" do
      before { model.image_url = 'http://filepicker.io/images/1' }

      it "displays the buttons showing the remove one" do
        rendered.should have_tag 'div', :with => { :class => 'filepicker-button' } do
          with_tag "a", :text => "Pick", :with => { :style => "display:none;" }
          with_tag "a", :text => "Remove", :with => { :style => "" }
        end
      end

      it "displays the image" do
        rendered.should have_tag "div", :with => { :class => 'filepicker-image', :style => '' } do
          with_tag "img", :alt => "image_url thumbnail", :src => "http://filepicker.io/images/1/convert?w=260&amp;h=180"
        end
      end

      it "displays the hidden input with a value" do
        rendered.should have_tag "input", :with => {
          :id => "test_model_image_url",
          :name => "test_model[image_url]",
          :type => "hidden",
          :value => "http://filepicker.io/images/1"
        }
      end
    end

  end
end