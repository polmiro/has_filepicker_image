module HasFilepickerImage
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      def has_filepicker_image(name, options = {})
        cattr_accessor :has_filepicker_image_styles
        self.has_filepicker_image_styles ||= {}
        self.has_filepicker_image_styles.merge!(name.to_sym => options[:styles])

        define_method name do |*args|
          UrlBuilder.new(
            :url    => read_attribute("#{name}_url"),
            :styles => self.class.has_filepicker_image_styles[name],
            :args   => args
          ).url
        end
      end
    end

  end
end