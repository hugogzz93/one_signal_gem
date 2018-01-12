require 'uri'
require 'net/http'


module OneSignal
  class Interface
    def initialize(options)
      @options = options
      @app_id = @options.app_id
      @uri = URI.parse(@options.uri)
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @http.use_ssl = true
    end

    def send_to_specific(user_ids, title, content)
      params = { 'include_player_ids' => user_ids,
                 'headings' => {'en' => title},
                 'contents' => {'en'=> content} }
      send_notification params
    end

    def send_notification(params)
      params['app_id'] = @app_id
      request = Net::HTTP::Post.new(@uri.path,
                                    'Content-Type'  => 'application/json;charset=utf-8',
                                    'Authorization' => "Basic NGEwMGZmMjItY2NkNy0xMWUzLTk5ZDUtMDAwYzI5NDBlNjJj")
      request.body = params.as_json.to_json
      response = @http.request(request)
      return response.body
    end
  end
end
