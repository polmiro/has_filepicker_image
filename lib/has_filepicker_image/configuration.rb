module HasFilepickerImage
  class Configuration
    attr_writer :api_key

    def initialize(*args)
      @conf = {
        'default' => {
          :delete_button_html => 'Remove',
          :pick_button_html   => 'Pick',
          :html_options => {
            :'data-location'      => 'S3',
            :'data-extensions'    => '.png,.jpg,.jpeg',
            :'data-services'      => 'COMPUTER',
            :'onchange'           => "HasFilepickerImage.previewPickedFile(event);"
          }
        }
      }
      @conf['default'][:html_options][:'data-debug'] = true if ::Rails.env.development? || ::Rails.env.test?
    end

    def api_key
      @api_key or raise "Set config.has_filepicker_image.api_key"
    end

    def defaults
      @conf['default']
    end

    def defaults=(opts)
      @conf['default'].merge!(opts)
    end

    def add_config(name, value)
      @conf[name] = value
    end

    def get_config(name)
      @conf[name]
    end

  end
end
