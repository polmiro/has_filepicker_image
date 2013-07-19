class FormtasticFilepickerImageInput
  include Formtastic::Inputs::Base

  def to_html
    input_wrapping do
      label_html <<
      builder.filepicker_image_field(method, input_html_options)
    end
  end
end
