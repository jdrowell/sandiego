#require 'rake'
#require 'rake/testtask'
#require 'rake/rdoctask'

#Dir["#{File.dirname(__FILE__)}/tasks/**/*.rake"].sort.each { |ext| load ext }

task :default do
  Dir["test/**/*.rb"].sort.each { |test|  load test }
end

task :fetch_citylite do
  `wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz`
  `gunzip GeoLiteCity.dat.gz`
end

