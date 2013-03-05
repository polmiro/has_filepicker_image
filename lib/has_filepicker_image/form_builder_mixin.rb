module HasFilepickerImage
  module FormBuilderMixin
    def filepicker_image_field(method, opts = {})
      config = ::Rails.application.config.has_filepicker_image

      value = object.send(method)
      options = config.defaults.merge(opts).merge(
        class: 'btn',
        value: value
      )

      content = ''

      if value.present?
        thumb_url = value + "/convert?w=260&h=180"
        thumb_alt = "#{method} thumbnail"
        preview = "<div class='filepicker-image'>#{@template.image_tag(thumb_url, alt: thumb_alt)}</div>"
        preview += "<a href='#' class='btn' data-action='removeImage'><i class='icon-trash'></i></a>" unless options[:'data-delete_button'] == false
        content = preview.html_safe
      else
        content = @template.content_tag(:a, 'Pick', options.merge(:href => '#', :'data-action' => 'pickImage'))
      end

      content + ActionView::Helpers::InstanceTag.new(
        @object_name,
        method,
        @template,
        object
      ).to_input_field_tag('hidden', options)
    end
  end
end