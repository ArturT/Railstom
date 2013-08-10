class TemplatesController < HighVoltage::PagesController
  layout false
  before_action :build_id

  private

  def build_id
    params[:id] = "templates/#{params[:id]}"
  end
end
