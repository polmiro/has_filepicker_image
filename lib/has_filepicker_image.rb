require 'rails'
require 'active_record'

module HasFilepickerImage
  require "has_filepicker_image/version"
  require "has_filepicker_image/configuration"
  require "has_filepicker_image/url_builder"
  require "has_filepicker_image/base"
  require "has_filepicker_image/helpers/view_helper"
  require "has_filepicker_image/helpers/form_builder_helper"
  require 'has_filepicker_image/helpers/simple_form_input' if defined? SimpleForm
  require 'has_filepicker_image/helpers/formtastic_form_input' if defined? Formtastic
  require "has_filepicker_image/engine"
end
