require "devcenter/version"
require "devcenter/source"
require 'restclient'
require 'ostruct'
require 'configliere'
require 'nokogiri'

Settings.resolve!

UserError = Class.new(RuntimeError)

module Devcenter
  extend self

  def pull!(id)
    raise "no session" unless @session
    begin
      response = resource["/admin/articles/edit/#{id}"].get(:cookies => @session, :accept => :html)
    rescue RestClient::ResourceNotFound => e
      raise UserError, "Could not find article with id #{id} at #{resource}"
    end
    doc = Nokogiri::HTML(response.body)
    STDERR.puts("writing article metadata")
    write({:id => id, :title => doc.css('#article_title').first['value']})  
    doc.css('#article_content').first.content
  end

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
    !! write(article)
  end

  def login!(email, password) 
    params = {:typus_user => {:email => email, :password => password}}
    @session = resource['/admin/session'].post(params) do |response, req, res| 
      response.cookies.tap do |cookies|
        cookies['_heroku_dev_center_session'] or raise UserError, "could not get a session for user #{email}"
      end
    end
    true
  end

  def resource
    @resource ||= begin
      url = ENV['DEVCENTER_URL'] || 'https://devcenter.heroku.com'
      RestClient::Resource.new(url)
    end
  end

  def write(article)
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
