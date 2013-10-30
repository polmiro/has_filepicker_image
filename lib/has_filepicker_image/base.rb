module HasFilepickerImage
  module Base
    extend ActiveSupport::Concern

    module ClassMethods

      def has_filepicker_image(name, options = {})
        cattr_accessor :has_filepicker_image_styles
        self.has_filepicker_image_styles ||= {}
        self.has_filepicker_image_styles.merge!(name.to_sym => options[:styles])

        define_method name do |*args|
          HasFilepickerImageUrlService.new(
            name:   name,
            url:    read_attribute("#{name}_url"),
            styles: self.class.has_filepicker_image_styles[name],
            args:   args
          ).url
        end
      end

      class HasFilepickerImageUrlService
        def initialize(params)
          @name     = params[:name]
          @base_url = params[:url]
          @styles   = params[:styles]
          @retrieval_options, @conversion_options = parse_options(*params[:args])
        end

        def url
          replace_asset_host(@base_url) + query_component if @base_url.present?
        end

        private

        def replace_asset_host(url)
          asset_host = Rails.application.config.has_filepicker_image.asset_host
          if asset_host
            uri = URI(url)
            uri.host = asset_host
            uri.to_s
          else
            url
          end
        end

        def parse_options(*args)
          retrieval_options = HashWithIndifferentAccess.new(:cache => true, :dl => 'false')
          conversion_options = HashWithIndifferentAccess.new

          if args.size > 2
            raise 'Wrong number of arguments' if args.size > 2
          elsif args.size > 0
            hash = {}
            arg = args[0]
            if arg.is_a?(Hash)
              hash.merge!(arg)
            else
              hash.merge!(args[1]) if args[1]
              hash[:w] = @styles[arg][0]
              hash[:h] = @styles[arg][1]
            end
            hash.assert_valid_keys(:w, :h, :fit, :dl, :cache)
            retrieval_options.merge!(hash.slice(:dl, :cache))
            conversion_options.merge!(hash.slice(:w, :h, :fit))
            conversion_options[:fit] ||= 'max' if conversion_options.present?
          end

          [retrieval_options, conversion_options]
        end

        def query_component
          component =  @conversion_options.present? ? '/convert' : ''
          component + '?' + all_options.map { |k,v| "#{k}=#{v}" }.join('&')
        end

        def all_options
          @retrieval_options.merge(@conversion_options)
        end

      end

    end

  end
end