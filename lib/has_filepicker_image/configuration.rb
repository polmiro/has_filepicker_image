module HasFilepickerImage
  class Configuration
    attr_writer :api_key
    attr_writer :defaults

    def initialize(*args)
      @defaults = {
        :'data-location'  => 'S3',
        :'data-extensions'      => '.png,.jpg,.jpeg',
        :'data-services' => 'COMPUTER',
        :'onchange'                => "HasFilepickerImage.previewPickedFile(event);",
      }
    end

    def api_key
      @api_key or raise "Set config.has_filepicker_image.api_key"
    end

    def defaults
      defaults = @defaults.dup
      defaults[:'data-debug']  = true     if ::Rails.env.development? || ::Rails.env.test?
      defaults
    end

  end
end