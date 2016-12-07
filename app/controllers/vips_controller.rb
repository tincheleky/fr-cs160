require 'net/http'
require 'json'

class VipsController < ApplicationController
  before_action :set_vip, only: [:show, :edit, :update, :destroy]

  # GET /vips
  # GET /vips.json
  def index
    @vips = Vip.all
  end

  # GET /vips/1
  # GET /vips/1.json
  def show
    puts "====================================================="
    puts @vip.image.url
  end

  # GET /vips/new
  def new
    @vip = Vip.new
  end

  # GET /vips/1/edit
  def edit
  end

  # POST /vips
  # POST /vips.json
  def create
    @vip = Vip.new(vip_params)
    uri = URI('https://api.projectoxford.ai/face/v1.0/facelists/vips/persistedFaces')
    uri.query = URI.encode_www_form({
        # Request parameters
    })

    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = '71e6768c33ae4b37b960d488c0b0ea17'
    # Request body
    request.body = {url: 'http://images.huffingtonpost.com/2016-07-22-1469200935-7760030-trump2-thumb.jpg'}.to_json

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end

    puts response.body
    data = JSON.parse(response.body)
    puts '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    @vip.img_name = data['persistedFaceId']
    puts params.inspect


    respond_to do |format|
      if @vip.save
        flash[:success] = "Photo saved!"
        format.html { redirect_to @vip, notice: 'Vip was successfully created.' }
        format.json { render :show, status: :created, location: @vip }
      else
        format.html { render :new }
        format.json { render json: @vip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vips/1
  # PATCH/PUT /vips/1.json
  def update
    respond_to do |format|
      if @vip.update(vip_params)
        format.html { redirect_to @vip, notice: 'Vip was successfully updated.' }
        format.json { render :show, status: :ok, location: @vip }
      else
        format.html { render :edit }
        format.json { render json: @vip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vips/1
  # DELETE /vips/1.json
  def destroy
    @vip.destroy
    respond_to do |format|
      format.html { redirect_to vips_url, notice: 'Vip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vip
      @vip = Vip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vip_params
      params.require(:vip).permit(:img_name, :img_type, :img_data, :size, :image)
    end
end


