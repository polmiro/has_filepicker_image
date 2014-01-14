require 'rails'
require 'active_record'

module HasFilepickerImage
  require "has_filepicker_image/version"
  require "has_filepicker_image/configuration"
  require "has_filepicker_image/url_builder"
  require "has_filepicker_image/view"
  require "has_filepicker_image/base"
  require "has_filepicker_image/helpers/view_helper"
  require "has_filepicker_image/helpers/form_builder_helper"
  require "has_filepicker_image/engine"

  begin
    require 'simple_form'
    require 'has_filepicker_image/helpers/simple_form_input'
  rescue LoadError
  end

  begin
    require 'formtastic'
    require 'has_filepicker_image/helpers/formtastic_form_input'
  rescue LoadError
  end
end
