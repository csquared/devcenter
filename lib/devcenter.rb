require "devcenter/version"
require "devcenter/source"
require 'restclient'

module Devcenter
  extend self

  def push!(article)
    raise "no session" unless @session
    resource['/admin/articles/create'].post(
      {:article => article}, 
      :cookies => @session, :accept => :html
    ) { |response, request, result| response }
  end

  def login!(email, password) 
    login_response = resource['/admin/session'].post(
      {:typus_user => {:email => email, :password => password}}
    ) { |response, request, result| response }
    @session = login_response.cookies.tap do |cookies|
      raise RuntimeError, "could not get a session" unless \
        cookies['_heroku_dev_center_session']
    end
  end

  def resource
    @resource ||= begin
      url = ENV['DEVCENTER_URL'] || 'https://devcenter.heroku.com'
      RestClient::Resource.new(url)
    end
  end
end
