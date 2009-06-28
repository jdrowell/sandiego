require 'rubygems'
require 'sinatra'

require 'geoip_city'
require 'yajl'

class Provider
  @@geodb = GeoIPCity::Database.new("GeoLiteCity.dat", :filesystem)

  def self.resolve(ip)
    @@geodb.look_up(ip) || { :country_code => nil }
  end
end
    
get '/geoip/:ip' do |ip|
  response['Content-Type'] = 'application-json'
  Yajl::Encoder.encode(Provider.resolve(ip))
end

