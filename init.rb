require "net/https"
require "uri"
require 'pony'
require_relative 'site'

pokupon = Site.new('https://pokupon.ua/')
partner = Site.new('https://partner.pokupon.ua/')

@sites = []
@sites << pokupon << partner

def check_statuses
  @sites.each do |site|
    uri = URI.parse(site.url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(request)
    if res.code == "200"
      site.current_status = true
    else
      site.current_status = false
    end
  end
end

def send_mail(subject, message)
    Pony.mail({
              :to                   => 'alert@pokupon.ua',
              :via                  => :smtp,
              :subject              => subject,
              :body                 => message,
              :via_options          => {
              :address              => 'smtp.gmail.com',
              :port                 => '587',
              :enable_starttls_auto => true,
              :user_name            => '',   #enter valid 
              :password             => '',   #enter valid password
              :authentication       => :plain,
              :domain               => "localhost.localdomain"
                                      }
            })
end

loop do
  check_statuses
  @sites.each do |site|
    if site.current_status == site.sended_status
      p site.url
      next
    elsif site.current_status == true && site.sended_status == false
      send_mail(
        "Your website #{site.url} is online!",
        "Your website is online since #{Time.now}"
               )
      site.sended_status = true
    else
      send_mail(
        "ERROR! Your website #{site.url} is offline!",
        "Your website is offline since #{Time.now}"
               )
      site.sended_status = false
    end
  end
  sleep 60
end