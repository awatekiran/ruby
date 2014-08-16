#!/usr/bin/ruby
require 'net/http'
require 'net/https'
require 'json'
require 'multi_json'

apiurl = "https://www.cloudflare.com/api_json.html"
token = "asdaasdasdasdasdasdasdadadasdadasdaas"  //get this value from my account section in cloudflare account //
mail = "test@example.com"

#fuction to fetch zones from cloudflare
uri = URI(apiurl)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Post.new(uri.request_uri)

request.set_form_data({"a" => "zone_load_multi", "tkn" => "#{token}", "email" => "#{mail}"})

response = http.request(request)
result = JSON(response.body)
#puts JSON.pretty_generate(result)
c=0
zonenames_array= []
result['response']['zones']['objs'].each do |zone|
   zonenames_array[c] = "#{zone['zone_name']}"
   c += 1
end

print zonenames_array //displayes zones present on cloudflare//

#function to fetch records for domains
uri = URI(apiurl)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Post.new(uri.request_uri)
#zonefile = open('zonefile.txt', 'w')
zonenames_array.each do | domain |
   testzone = open(domain, 'w')
   request.set_form_data({"a" => "rec_load_all", "tkn" => "#{token}", "email" => "#{mail}", "z" => "#{domain}"})
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