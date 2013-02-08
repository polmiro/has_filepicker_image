module HasFilepickerImage
  class Engine < ::Rails::Engine

    config.has_filepicker_image = HasFilepickerImage::Configuration.new

    ActiveSupport.on_load(:action_view) do
      class ActionView::Base
        include HasFilepickerImage::ViewHelper
      end

      class ActionView::Helpers::FormBuilder
        include HasFilepickerImage::FormBuilderMixin
      end
    end

    ActiveRecord::Base.send(:include, HasFilepickerImage::Base)

  end
end