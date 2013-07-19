module HasFilepickerImage
  class Configuration
    attr_writer :api_key

    def initialize(*args)
      @defaults = {
        :delete_button_html => 'Remove',
        :pick_button_html   => 'Pick',
        :html_options => {
          :'data-location'      => 'S3',
          :'data-extensions'    => '.png,.jpg,.jpeg',
          :'data-services'      => 'COMPUTER',
          :'data-delete_button' => true,
          :'onchange'           => "HasFilepickerImage.previewPickedFile(event);"
        }
      }
      @defaults[:html_options][:'data-debug'] = true if ::Rails.env.development? || ::Rails.env.test?
    end

    def api_key
      @api_key or raise "Set config.has_filepicker_image.api_key"
    end

    def defaults
      @defaults
    end

    def defaults=(opts)
      @defaults.merge!(opts)
    end

  end
end