module Sportsdata
  module Request
    module ClassMethods
      class Exception < ::Exception
      end

      #the methods below must be extended in each class
      def api_key
        raise Sportsdata::Exception, "api key is not configured"
      end

      def api_mode
        raise Sportsdata::Exception, "api mode is not configured"
      end

      def version
        raise Sportsdata::Exception, "version is not configured"
      end

      def name
        raise Sportsdata::Exception, "name is not configured"
      end

      def base_url
        "http://api.sportsdatallc.org/#{self.name}-#{self.api_mode}#{self.version}"
      end

      #do not change the methods below
      def api
        Faraday.new self.base_url do |a|
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
                      elsif response.headers.has_key?("x-mashery-error-code")
                        response.headers[:x_mashery_error_code]
                      else
                        "The server did not specify a message"
                      end
            raise message
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
          404 => "Not Found"
        }
      end
    end
    extend ClassMethods
    def self.included( base )
      base.extend( ClassMethods )
    end
  end
end
