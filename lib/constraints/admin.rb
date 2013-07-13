module Constraint
  class Admin
    def self.matches?(request)
      if request.session && request.session.has_key?('warden.user.user.key')
        user_id = request.session['warden.user.user.key'][0][0].to_i
        user = User.find(user_id)
        user && user.admin?
      else
        false
      end
    end
  end
end
