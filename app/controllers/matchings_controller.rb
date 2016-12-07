require 'net/http'
require 'json'

class MatchingsController < ApplicationController
	IP_PORT = 'http://67.188.93.111:3000'

	def new 
		@matching = Matching.new
	end

	def show
	end

	def create
		@matching = Matching.new(matching_params)
		
		#Detect the face
		@matching.save
		uri = URI('https://api.projectoxford.ai/face/v1.0/detect')
	    uri.query = URI.encode_www_form({
	        # Request parameters
	        'returnFaceId' => 'true'
	    })

	    request = Net::HTTP::Post.new(uri.request_uri)
	    # Request headers
	    request['Content-Type'] = 'application/json'
	    # Request headers
	    request['Ocp-Apim-Subscription-Key'] = '71e6768c33ae4b37b960d488c0b0ea17'
	    # Request body
	    request.body = {url: "#{IP_PORT}#{@matching.image.url}"}.to_json

	    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
	        http.request(request)
	    end

	    puts response.body
	    data = JSON.parse(response.body)
	    puts 'matchings_controller_create API: Face detect +++++++++++++++++++++++++++++++++++++++++++++++++++++'
	    @faceID = data[0]['faceId']
		puts '============================================================='
		puts @matching
		#puts params.inspect
		puts "________faceID________"
		#puts "#{IP_PORT}#{@matching.image.url}"
		puts @faceID

		#Find the face in faceList

		uri = URI('https://api.projectoxford.ai/face/v1.0/findsimilars')
		uri.query = URI.encode_www_form({
			# Request Parameters:
			'persistedFaceId' => 'string'
		})

		request = Net::HTTP::Post.new(uri.request_uri)
		# Request headers
		request['Content-Type'] = 'application/json'
		# Request headers
		request['Ocp-Apim-Subscription-Key'] = '71e6768c33ae4b37b960d488c0b0ea17'
		# Request body
		request.body = {    
		    "faceId" => @faceID,
		    "faceListId" => "vips",  
		    "maxNumOfCandidatesReturned" => 5,
		    "mode" => "matchFace"
		}.to_json

		response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
		    http.request(request)
		end
	    puts 'matchings_controller_create API: Face findSimilar +++++++++++++++++++++++++++++++++++++++++++++++++++++'
		puts response.body
		@face = Array.new
		@percentage = Array.new
		data = JSON.parse(response.body)
		data.each do |res|
			puts res['persistedFaceId']
			vip = Vip.find_by img_name: res['persistedFaceId']
			if vip != nil
				@face << vip
				@percentage << res['confidence']
				puts "Found: " + vip.img_name
				puts "Found: " + (res['confidence'] * 100 ).to_s
			end 
		end





	end

	def matching_params
      params.require(:matching).permit(:image)
    end
end
