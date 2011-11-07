require "devcenter/version"
require "devcenter/source"
require 'restclient'

module Devcenter
  extend self

  def push!(article)
    raise "no session" unless @session
    action = article[:id] ? "update/#{article[:id]}" : 'create'
    response = resource["/admin/articles/#{action}"].post(
      {:article => article}, 
      :cookies => @session, :accept => :html
    ) { |response, request, result| response }

    if action == 'create' 
      response.headers[:location] or raise "duplicate article title" 
      article[:id] = response.headers[:location].split("/").last
      File.open("article.yml", "w") do |file|
        YAML.dump({
          :article => {
            :id => article[:id],
            :title => article[:title]
          }
        }, file)
      end
    end
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
