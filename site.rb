class Site
    
  attr_reader :url
  attr_accessor :current_status, :sended_status
    
  def initialize(url, current_status = false, sended_status = true)
    @url            = url
    @current_status = current_status
    @sended_status  = sended_status
  end
    
end