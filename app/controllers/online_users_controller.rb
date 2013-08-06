class OnlineUsersController < ApplicationController
  include ActionController::Live

  def users
    response.headers['Content-Type'] = 'text/event-stream'
    sse   = Reloader::SSE.new(response.stream)
    redis = Redis.new

    redis.subscribe('online-users') do |on|
      on.message do |event, data|
        sse.write(JSON.parse(data), event: 'online-users')
      end
    end
    render nothing: true
  rescue IOError => ioerror
    Rails.logger.error ioerror
  ensure
    redis.quit
    sse.close
  end
end
