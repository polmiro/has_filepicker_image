module HasFilepickerImage
  class Configuration
    attr_writer :api_key

    def initialize(*args)
      @conf = HashWithIndifferentAccess.new

      @conf[:default] = {
        :delete_button_html => 'Remove',
        :pick_button_html   => 'Pick',
        :html_options => {
          :'data-location'      => 'S3',
          :'data-extensions'    => '.png,.jpg,.jpeg',
          :'data-services'      => 'COMPUTER',
          :'onchange'           => "HasFilepickerImage.previewPickedFile(event);"
        }
      }

      if ::Rails.env.development? || ::Rails.env.test?
        @conf[:default][:html_options][:'data-debug'] = true
      end
    end

    def api_key
      @api_key or raise "Set config.has_filepicker_image.api_key"
    end

    def defaults
      @conf[:default]
    end

    def defaults=(opts)
      @conf[:default] = opts
    end

    def add_config(name, value)
      @conf[name] = value
    end

    def get_config(name = nil)
      if name
        unless @conf.has_key?(name)
          raise 'HasFilepickerImage configuration does not exist'
        end
        @conf[name]
      else
        defaults
      end
    end
  end
end
