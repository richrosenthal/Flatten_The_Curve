require './config/environment'
require 'twilio-ruby'


class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

#   get '/test' do
#     content_type 'text/xml'
#
#     Twilio::TwiML::VoiceResponse.new do | response |
#       response.say(message: 'Hello World')
#   end.to_s
# end

  get "/" do
    erb :welcome
  end




  post "/information" do
    @city = params["city"]
    @state = params["state"]
    @name = params["name"]

    @age = params["age"].to_i

    symptoms = ""
    preexistingcond = ""
if (@age > 60 && (params["fever"] || params["cough"] || params["fatigue"])) || ((params["fever"] || params["cough"] || params["fatigue"]) && (params["lung"] || params["heart"] || params["immunecomp"] || params["bmi"]))

    if params["fever"]
      symptoms << " fever "
    end
    if params["cough"]
      symptoms << " cough "
    end
    if params["fatigue"]
      symptoms << " fatigue"
    end

    if params["lung"] || params["heart"] || params["immunecomp"] || params["bmi"]
      preexistingcond = "The patient also has preexisting conditions per CDC guidelines"
    end


@map_key = ENV['Maps_Key']
account_sid = ENV['TWILIO_ACCOUNT_SID']

auth_token = ENV['Twilio_API_KEY']
client = Twilio::REST::Client.new(account_sid, auth_token)

from = '+12055513069' # Your Twilio number
to = "+1#{params["phone"]}" # Your mobile phone number

client.messages.create(
from: from,
to: to,
body: "Patient (#{@name}), living in #{@city},#{@state} is at risk and has the following symptoms: #{symptoms}.
      and is age: #{@age}. #{preexistingcond}
      "
)




       erb :at_risk
    else
      erb :not_at_risk
    end
  end

 get "/postive-result" do

  end

  get "/negative-result" do

  end


end
