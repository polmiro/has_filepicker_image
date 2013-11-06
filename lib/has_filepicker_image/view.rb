module HasFilepickerImage
  class View
    def initialize(object_name, attribute_name, template, options = {})
      @object_name = object_name
      @attribute_name = attribute_name
      @template = template
      @options = options
    end

    def render
      buttons + preview + hidden_field
    end

    private

    def buttons
      @template.content_tag(
        :div,
        pick_button + remove_button,
        :class => 'filepicker-button'
      )
    end

    def preview
      @template.content_tag(:div, :class => 'filepicker-image', :style => (value.present? ? '' : 'display:none;')) do
        if value.present?
          # Render preview + Delete link
          thumb_url = value + "/convert?w=260&h=180"
          thumb_alt = "#{@attribute_name} thumbnail"
          @template.image_tag(thumb_url, alt: thumb_alt )
        end
      end
    end

    def hidden_field
      if Rails::VERSION::MAJOR >= 4
        ActionView::Helpers::Tags::HiddenField.new(
          @object_name,
          @attribute_name,
          @template,
          :object => object
        ).render
      else
        ActionView::Helpers::InstanceTag.new(
          @object_name,
          @attribute_name,
          @template,
          object
        ).to_input_field_tag('hidden')
      end
    end

    def pick_button
      @template.content_tag(:a,
        @options[:pick_button_html],
        html_options.merge(
          :href  => '#',
          :style => value.present? ? 'display:none;' : '',
          :'data-action' => 'pickImage'
        )
      )
    end

    def remove_button
      @template.link_to(
        @options[:delete_button_html],
        '#',
        :style => value.present? ? '' : 'display:none;',
        :'data-action' => 'removeImage'
      )
    end

    def value
      object.send(@attribute_name)
    end

    def object
      @options[:object]
    end

    def html_options
      @options[:html_options] || {}
    end
  end
end
