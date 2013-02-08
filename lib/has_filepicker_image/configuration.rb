module HasFilepickerImage
  class Configuration
    attr_writer :api_key
    attr_writer :defaults
    attr_accessor :replaceable

    def initialize(*args)
      @replaceable = true
      @defaults = {
        :'data-fp-store-location'  => 'S3',
        :'data-fp-extensions'      => '.png,.jpg,.jpeg',
        :'data-fp-option-services' => 'COMPUTER',
        :'data-fp-button-text'     => 'Pick File',
        :'onchange'                => "HasFilepickerImage.previewPickedFile(event);",
      }
    end

    def api_key
      @api_key or raise "Set config.has_filepicker_image.api_key"
    end

    def defaults
      defaults = @defaults.dup
      defaults[:'data-fp-apikey'] = api_key
      defaults[:'data-fp-debug']  = true     if ::Rails.env.development? || ::Rails.env.test?
      defaults
    end

  end
end