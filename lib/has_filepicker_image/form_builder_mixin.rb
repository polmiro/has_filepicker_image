module HasFilepickerImage
  module FormBuilderMixin
    def filepicker_image_field(method, opts = {})
      config = ::Rails.application.config.has_filepicker_image
      options = config.defaults.dup
      options[:value] = object.send(method)

      extra_content = ''

      if object.send(method).present? && config.replaceable
        options[:'data-fp-button-text'] = 'Replace'
        thumb_url = object.send(method) + "/convert?w=260&h=180"
        thumb_alt = "#{method} thumbnail"
        extra_content = "<div class='filepicker-image'>#{@template.image_tag(thumb_url, alt: thumb_alt)}</div>".html_safe
      end

      options.merge!(opts)

      instance_tag = ActionView::Helpers::InstanceTag.new(@object_name, method, @template, object)
      input_field_tag = instance_tag.to_input_field_tag('filepicker', options)
      input_field_tag + extra_content
    end
  end
end