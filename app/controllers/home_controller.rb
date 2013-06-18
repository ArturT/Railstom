class HomeController < ApplicationController
  def index
  end

  def locale_root
    flash.keep
    redirect_to :root
  end
end
