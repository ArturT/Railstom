# TODO You can use this worker to publish on user's stream
class FacebookFeedWorker
  include Sidekiq::Worker

  # feed_hash example:
  # {
  #   :message => 'Updating via FbGraph',
  #   :picture => 'https://graph.facebook.com/matake/picture',
  #   :link => 'https://github.com/nov/fb_graph',
  #   :name => 'FbGraph',
  #   :description => 'A Ruby wrapper for Facebook Graph API'
  # }
  def perform(user_id, feed_hash)
    authentication = Authentication.find_by(user_id: user_id)

    unless authentication.nil?
      fb_user_uid = authentication.uid

      app = FbGraph::Application.new(Figaro.env.provider_facebook_app_id, secret: Figaro.env.provider_facebook_app_secret)
      app_access_token = app.get_access_token.access_token

      fb_user = FbGraph::User.fetch(fb_user_uid, access_token: app_access_token)
      fb_user.feed!(feed_hash)
    end
  end
end
