require 'sinatra'
#require 'ruby-debug/debugger'
require 'geoip_city'
require 'yajl'
require 'iconv'

module GeoIP
  class Application < Sinatra::Base
    NOWHERE = {:country_code=>"XX", :country_code3=>"XXX", :country_name=>"XXX", :region=>"0", :city=>"XXX", :latitude=>360.0, :longitude=>360.0}
    @@geodb = GeoIPCity::Database.new('GeoLiteCity.dat', :filesystem)

    def force_utf8(s)
      if RUBY_VERSION >= '1.9'
        s.force_encoding('ISO-8859-1').encode('UTF-8')
      else
        Iconv.conv('UTF-8', 'ISO-8859-1', s)
      end
    end

    def resolve(ip)
      return NOWHERE unless res = @@geodb.look_up(ip)
      [:country_code, :country_code3, :country_name, :region, :city].each do |field|
        res[field] = force_utf8(res[field])
      end
      res
    end

    get '/geoip/:ip' do |ip|
      content_type :json
      Yajl::Encoder.encode(resolve(ip))
    end
  end
end
    

