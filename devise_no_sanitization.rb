#This is a useful script to test peoples custom validations that override
#devise's built in validations
#Using nokogiri to parse responses by restclient requests
#write example rails app the uses devise and modifies validations insecurely
require 'rubygems'
require 'nokogiri'
require 'restclient'
require 'colorize'

#could use new and create action urls as params to script instead
# ie new_route=http://localhost:3000/users/sign_up
# create_route="http://localhost:3000/users/
target_rails_host  = "localhost"
target_rails_port = "3000"
payload = "&lt;script>console.log('hi there');&lt;/script>@."

sign_up_page_response = RestClient.get("http://#{target_rails_host}:#{target_rails_port}/users/sign_up")

#grab the session cookie
session_cookie = sign_up_page_response.cookies

puts "Acquired session cookie from sign_up page".colorize(:blue)
puts session_cookie.to_s.colorize(:green)

#grab the last csrf-token in the response (should only be one anyway)
sign_up_page = Nokogiri::HTML(sign_up_page_response)
csrf_tag   = sign_up_page.xpath("//meta[@name='csrf-token']").last
csrf_token = csrf_tag.attribute "content"

puts "Acquired csrf_token from sign_up page".colorize(:blue)
puts csrf_token.to_s.colorize(:green)

url = "http://#{target_rails_host}:#{target_rails_port}/users/"
params = {
  user: {email:payload, password:"qwerty123"},
  "commit"=>"Log in",
  "authenticity_token" => csrf_token
}
#don't forget to include the session_cookie or the csrf-token will be changed by
#the rails application.
headers = {
  "X-CSRF-Token" => csrf_token,
  :cookies => session_cookie
}

post_sign_up = RestClient.post url, params, headers

post_sign_up.split("\n").each do |line|
  next if line.empty?
  if line.include? "field_with_errors"
    puts line.colorize(:red)
  else
    puts line.colorize(:light_blue)
  end
end

puts "\nIf this failed, then the email field is validated correctly."
