module Sportsdata
  module Request
    module ClassMethods
      class Exception < ::Exception
      end

      #the methods below must be extended in each class
      def api_key
        raise Sportsdata::Exception, "api key is not configured"
      end

      def images_api_key
        raise Sportsdata::Exception, "images_api key is not configured"
      end

      def api_mode
        raise Sportsdata::Exception, "api mode is not configured"
      end

      def images_api_mode
        raise Sportsdata::Exception, "images_api mode is not configured"
      end

      def version
        raise Sportsdata::Exception, "version is not configured"
      end

      def images_version
        raise Sportsdata::Exception, "images version is not configured"
      end

      def name
        raise Sportsdata::Exception, "name is not configured"
      end

      def base_url
        "http://api.sportsdatallc.org/#{self.name}-#{self.api_mode}#{self.version}"
      end

      def images_base_url
        "http://api.sportsdatallc.org/#{self.name}-images-#{self.images_api_mode}#{self.images_version}"
      end

      #do not change the methods below
      def api
        Faraday.new self.base_url do |a|
          a.response :xml, :content_type => /\bxml$/
          a.adapter Faraday.default_adapter
        end
      end

      def images_api
        Faraday.new self.images_base_url do |a|
          a.response :xml, :content_type => /\bxml$/
          a.adapter Faraday.default_adapter
        end
      end

      def get(url)
        begin
          response = self.api.get(url, { :api_key => self.api_key })
          if response.status != 200
            message = if response.headers.has_key?("x-server-error")
                        JSON.parse(response.headers[:x_server_error], { symbolize_names: true })[:message]
                      elsif response.headers.has_key?("x-feed-error")
                        response.headers["x-feed-error"]
                      elsif response.headers.has_key?("x-mashery-error-code")
                        response.headers[:x_mashery_error_code]
                      else
                        "The server did not specify a message"
                      end
            if message.include?('Unknown Season')
              return response.body
            elsif message.include?('InvalidSeasonException')
              return response.body
            else
              return []
              #raise message
            end
          else
            return response.body
          end
        rescue Faraday::Error::TimeoutError => timeout
          raise Sportsdata::Exception, 'Sportsdata Timeout Error'
        rescue Exception => e
          message = if e.response.headers.has_key?("x-server-error")
                      JSON.parse(e.response.headers[:x_server_error], { symbolize_names: true })[:message]
                    elsif e.response.headers.has_key?("x-mashery-error-code")
                      e.response.headers[:x_mashery_error_code]
                    else
                      "The server did not specify a message"
                    end
          raise Sportsdata::Exception, message
        end
      end

      def images_get(url)
        begin
          response = self.images_api.get(url, { :api_key => self.images_api_key })
          if response.status != 200
            message = if response.headers.has_key?("x-server-error")
                        JSON.parse(response.headers[:x_server_error], { symbolize_names: true })[:message]
                      elsif response.headers.has_key?("x-feed-error")
                        response.headers["x-feed-error"]
                      elsif response.headers.has_key?("x-mashery-error-code")
                        response.headers[:x_mashery_error_code]
                      else
                        "The server did not specify a message"
                      end
            if message.include?('Unknown Season')
              return response.body
            elsif message.include?('InvalidSeasonException')
              return response.body
            else
              raise message
            end
          else
            return response.body
          end
        rescue Faraday::Error::TimeoutError => timeout
          raise Sportsdata::Exception, 'Sportsdata Timeout Error'
        rescue Exception => e
          message = if e.response.headers.has_key?("x-server-error")
                      JSON.parse(e.response.headers[:x_server_error], { symbolize_names: true })[:message]
                    elsif e.response.headers.has_key?("x-mashery-error-code")
                      e.response.headers[:x_mashery_error_code]
                    else
                      "The server did not specify a message"
                    end
          raise Sportsdata::Exception, message
        end
      end



      def errors
        @errors = {
          0 => "OK",
          1 => "No Response",
          200 => "Successful",
          400 => "Bad Request",
          400 => "ERR_INVALID_APIKEY",
          400 => "ERR_INVALID_DATE_RANGE_EXCEEDS_7_DAY_MAX",
          400 => "ERR_INVALID_END_DATE",
          400 => "ERR_INVALID_ERRORCODE_LIMIT",
          400 => "ERR_INVALID_FORMAT",
          400 => "ERR_INVALID_LIMIT",
          400 => "ERR_INVALID_METHOD_LIMIT",
          400 => "ERR_INVALID_SERVICE_DEV_KEY",
          400 => "ERR_INVALID_SERVICE_KEY",
          400 => "ERR_INVALID_SIG",
          400 => "ERR_INVALID_SITE_ID",
          400 => "ERR_INVALID_START_DATE",
          403 => "Forbidden",
          403 => "Developer Inactive",
          403 => "Not Authorized",
          403 => "Account Inactive",
          403 => "Account Over Queries Per Second Limit",
          403 => "Account Over Rate Limit",
          403 => "Unknown Referrer",
          403 => "Service Over Quesries-per-Second-Limit",
          403 => "Service Requires SSL",
          403 => "Rate Limit Exceeded",
          404 => "Not Found",
          414 => "Requst URI Too Long",
          502 => "Bad Gateway",
          503 => "API Maintenance/Service Unavailable"
        }
      end
    end
    extend ClassMethods
    def self.included( base )
      base.extend( ClassMethods )
    end
  end
end
