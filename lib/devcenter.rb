require "devcenter/version"
require "devcenter/source"
require 'restclient'
require 'ostruct'
require 'configliere'

Settings.resolve!

UserError = Class.new(RuntimeError)

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
      response.headers[:location] or raise UserError, "problem saving article" 
      puts "created new article"
      edit_page  = response.headers[:location]
      article[:id] = edit_page.split("/").last
      `open #{edit_page}` if Settings[:open]
    else
      puts "updated article"
      `open #{resource["/admin/articles/edit/#{article[:id]}"]}` if Settings[:open]
    end

    puts "writing article metadata to article.yml"
    File.open("article.yml", "w") do |file|
      YAML.dump({
        :article => {
          :id => article[:id],
          :title => article[:title]
        }
      }, file)
    end
  end

  def login!(email, password) 
    login_response = resource['/admin/session'].post(
      {:typus_user => {:email => email, :password => password}}
    ) { |response, request, result| response }
    @session = login_response.cookies.tap do |cookies|
      raise UserError, "could not get a session for user #{email}" unless \
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
