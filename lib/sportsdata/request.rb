module Request
  class Exception < ::Exception
  end

  #def self.api_key
  #  Sportsdata.nba_api_key
  #end

  #def self.api_mode
  #  Sportsdata.api_mode
  #end

  #def self.version
  #  "1"
  #end

  def self.base_url
    debugger
    "http://api.sportsdatallc.org/nfl-#{self.api_mode}#{self.version}"
  end

  def self.api
    Faraday.new self.base_url do |a|
      a.response :xml, :content_type => /\bxml$/
      a.adapter Faraday.default_adapter
    end
  end

  def self.get_raw(url)
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

  def self.errors
    @errors = {
      0 => "OK",
      1 => "No Response",
      200 => "Successful",
      404 => "Not Found"
    }
  end
end

extend Request
def self.included( other )
  other.extend( Request )
end
