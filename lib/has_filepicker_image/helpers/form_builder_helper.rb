module HasFilepickerImage
  module FormBuilderHelper
    def filepicker_image_field(attribute_name, opts = {})
      config = Rails.application.config.has_filepicker_image

      value = object.send(attribute_name)
      options = config.defaults.deep_merge(opts)
      html_options = options[:html_options] || {}

      content = if value.present?
        # Render preview + Delete link
        thumb_url = value + "/convert?w=260&h=180"
        thumb_alt = "#{attribute_name} thumbnail"

        preview = "<div class='filepicker-image'>#{@template.image_tag(thumb_url, alt: thumb_alt)}</div>"
        preview += "<a href='#' class='btn' data-action='removeImage'>#{options[:delete_button_html]}</a>" if html_options[:'data-delete_button']
        preview.html_safe
      else
        # Render Add link
        "<div class='filepicker-image'></div>".html_safe +
        @template.content_tag(:a,
          options[:pick_button_html],
          html_options.merge(
            :href  => '#',
            :value => value,
            :'data-action' => 'pickImage'
          )
        )
      end

      content + ActionView::Helpers::InstanceTag.new(
        @object_name,
        attribute_name,
        @template,
        object
      ).to_input_field_tag('hidden')
    end
  end
end