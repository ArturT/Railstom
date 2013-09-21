class Injector
  include Dependor::AutoInject
  extend Dependor::Let

  def initialize(current_user = nil, request = nil)
    @current_user = current_user
    @request = request
  end

  let(:current_user) { @current_user }
  let(:request) { @request }
  let(:omniauth_hash) { @request.env['omniauth.auth'] }

  %w(User Authentication).each do |klass|
    define_method "db_#{klass.underscore}" do
      klass.constantize
    end
  end
end
