require 'sinatra/base'                
require 'haml'   
require 'sass'
require "rdiscount"               
require 'haml-coderay'       
require 'sinatra/content_for2'
require 'sinatra/static_assets'
require 'sinatra/url_for'

class App < Sinatra::Base                 
  helpers Sinatra::ContentFor2
  register Sinatra::StaticAssets          
  helpers Sinatra::UrlForHelper                               
  
  Haml::Filters::CodeRay.encoder_options = { :css => :class } 
  set :markdown, :layout_engine => :haml, :layout => :layout     
  
  ['/', '/blog'].each do |path|
    get path do                                          
      posts = Dir.new(File.join(File.dirname(__FILE__), '..', 'views', "posts")).entries
      posts.delete('.')
      posts.delete('..')
        
      @posts = []
      posts.each do |post|                                     
        @posts << { title: post, url: '/blog/' + post.sub(/\.\w*$/,'') }
      end
                  
      haml :blog
    end    
  end 
  
  get '/blog/:name' do    
    markdown :"posts/#{params[:name]}"
  end

  get '/proyectos' do
    haml :proyectos
  end              

  get '/about' do
    haml :about
  end         

  get '/:id.css' do
    sass :"scss/#{params[:id]}"
  end     
  # start the server if ruby file executed directly
  run! if app_file == $0
end     

module Haml
  module Helpers
    def partial(template, *args)
      template_array = template.to_s.split('/')
      template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:layout => false)
      if collection = options.delete(:collection) then
        collection.inject([]) do |buffer, member|
          buffer << haml(:"#{template}", options.merge(:layout =>
          false, :locals => {template_array[-1].to_sym => member}))
        end.join("\n")
      else
        haml(:"#{template}", options)
      end
    end
  end
end