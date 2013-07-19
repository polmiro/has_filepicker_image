module SimpleForm
  module Inputs
    class FilepickerImageInput < Base

      def input
        @builder.filepicker_image_field(attribute_name, input_html_options)
      end
    end
  end
end
