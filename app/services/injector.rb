class Injector
  include Dependor::AutoInject

  def initialize(current_user = nil, request = nil)
    @current_user = current_user
    @request = request
  end

  let(:omniauth_hash) { @request.env['omniauth.auth'] }

  %w(User Authentication).each do |klass|
    define_method "db_#{klass.underscore}" do
      klass.constantize
    end
  end
end
