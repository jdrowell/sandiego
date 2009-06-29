require 'rubygems'
require 'sinatra'
#require 'ruby-debug/debugger'

require 'geoip_city'
require 'yajl'
require 'iconv'

mime :json, 'application/json'

class Provider
  @@geodb = GeoIPCity::Database.new("GeoLiteCity.dat", :filesystem)
  @@to_charset = 'utf8'
  @@from_charset = 'iso-8859-1'

  def self.resolve(ip)
    res = @@geodb.look_up(ip) || { :country_code => nil }
    [:city, :country_name].each do |field|
      res[field] = Iconv.conv(@@to_charset, @@from_charset, res[field])
    end
    res
  end
end
    
get '/geoip/:ip' do |ip|
  content_type :json
  Yajl::Encoder.encode(Provider.resolve(ip))
end

