require 'dependor/shorty'

class Injector
  include Dependor::AutoInject

  def initialize(current_user = nil, request = nil)
    @current_user = current_user
    @request = request
  end

  let(:current_user) { @current_user }
  let(:request) { @request }
  let(:omniauth_hash) { request.env['omniauth.auth'] }

  %(User Authentication).each do |klass|
    define_method "db_#{klass.name.underscore}" do
      klass.constantize
    end
  end
end
