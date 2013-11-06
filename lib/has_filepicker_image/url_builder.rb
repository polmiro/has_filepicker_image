module HasFilepickerImage
  class UrlBuilder
    def initialize(options)
      @url        = options[:url]
      @options    = ApiOptions.new(options[:styles], *options[:args])
      @asset_host = Rails.application.config.has_filepicker_image.asset_host
    end

    def url
      replace_asset_host(@url) + query_component if @url.present?
    end

    private

    def replace_asset_host(url)
      if @asset_host
        uri = URI(url)
        uri.host = @asset_host
        uri.to_s
      else
        url
      end
    end

    def query_component
      component =  @options.with_conversion_options? ? '/convert' : ''
      component + '?' + @options.map { |k,v| "#{k}=#{v}" }.join('&')
    end

    class ApiOptions < HashWithIndifferentAccess
      CONVERSION_OPTIONS = [:w, :h, :fit]
      RETRIEVAL_OPTIONS  = [:dl, :cache]
      DEFAULT_OPTIONS    = {:cache => true, :dl => 'false', :fit => 'max'}
      ALL_OPTIONS = RETRIEVAL_OPTIONS + CONVERSION_OPTIONS

      def initialize(styles, hash_or_style = {}, hash = {})
        @styles = styles

        options = if hash_or_style.is_a?(Hash)
          hash_or_style.assert_valid_keys(*ALL_OPTIONS)
          hash_or_style
        else
          hash.assert_valid_keys(*ALL_OPTIONS)
          style_api_options(hash_or_style).merge(hash)
        end

        merge! options
        reverse_merge! defaults(options)
      end

      def with_conversion_options?
        (keys & CONVERSION_OPTIONS).present?
      end

      private

      def defaults(options)
        if with_conversion_options?
          DEFAULT_OPTIONS
        else
          DEFAULT_OPTIONS.slice(*RETRIEVAL_OPTIONS)
        end
      end

      def style_api_options(style)
        {
          :w => @styles[style][0],
          :h => @styles[style][1]
        }
      end
    end

  end
end
