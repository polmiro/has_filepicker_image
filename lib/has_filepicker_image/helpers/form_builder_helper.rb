module HasFilepickerImage
  module FormBuilderHelper
    def filepicker_image_field(attribute_name, *args)
      filepicker_field(attribute_name, *args)
    end

    def filepicker_field(attribute_name, *args)
      raise ArgumentError.new if args.size > 2

      config = Rails.application.config.has_filepicker_image
      config_name = nil
      opts = {}

      case
        when args.size == 1 && args[0].is_a?(Hash)
          opts = args[0]
        when args.size == 1 && !args[0].is_a?(Hash)
          config_name = args[0]
        when args.size == 2
          config_name, opts = args
      end

      View.new(
        @object_name,
        attribute_name,
        @template,
        config.get_config(config_name)
          .deep_merge(opts)
          .merge(:object => object)
      ).render
    end

  end
end
