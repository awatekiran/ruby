#!/usr/bin/ruby
require 'net/http'
require 'net/https'
require 'rubygems'
require 'net/smtp'
require 'json'
require 'fileutils'

$apiurl = "https://www.cloudflare.com/api_json.html"
$token = "adasdasdadasdasdasdasdasdasdasdas"
$mail = "test@test.com"
$zonenames_array = []

  uri = URI($apiurl)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new(uri.request_uri)

  request.set_form_data({"a" => "zone_load_multi", "tkn" => "#{$token}", "email" => "#{$mail}"})

  response = http.request(request)
  result = JSON(response.body)
#puts JSON.pretty_generate(result)
  c=0
#zonenames_array= []
  result['response']['zones']['objs'].each do |zone|
    $zonenames_array[c] = "#{zone['zone_name']}"
    c += 1
  end

      #print $zonenames_array

def get_records()
   uri = URI($apiurl)
   http = Net::HTTP.new(uri.host, uri.port)
   http.use_ssl = true
   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
   request = Net::HTTP::Post.new(uri.request_uri)
      #zonefile = open('zonefile.txt', 'w')
   FileUtils.cd('/home/test/folder/') do
      $zonenames_array.each do | domain |
         testzone = open(domain, 'w')
         request.set_form_data({"a" => "rec_load_all", "tkn" => "#{$token}", "email" => "#{$mail}", "z" => "#{domain}"})
         response = http.request(request)
         result = JSON(response.body)
    # puts JSON.pretty_generate(result)
         result['response']['recs']['objs'].each do | entry |
            if entry['ttl'] == "1"
               live = "300"
            else
               live = entry['ttl']
            end
            newentry = entry['name']+" "+live+" IN "+entry['type']+" "+entry['content']
            testzone.write(newentry)
            testzone.write("\n")
         end
         testzone.close
      end
   end
end

get_records()
