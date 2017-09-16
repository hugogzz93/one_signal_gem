require 'URI'
require 'net/http'


module OneSignal
  class Interface
    def initialize
      @app_id = "1c00fa72-c932-410d-85be-20213f89328b"
      @uri = URI.parse('https://onesignal.com/api/v1/notifications')
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @http.use_ssl = true
    end

    def send_to_specific(user_ids)
      params = {'include_player_ids' => user_ids}
      send_notification params
    end

    def send_notification(params)
      params['app_id'] = @app_id
      request = Net::HTTP::Post.new(@uri.path,
                                    'Content-Type'  => 'application/json;charset=utf-8',
                                    'Authorization' => "Basic NGEwMGZmMjItY2NkNy0xMWUzLTk5ZDUtMDAwYzI5NDBlNjJj")
      request.body = params.as_json.to_json
      response = @http.request(request)
      puts response.body
    end
  end
end