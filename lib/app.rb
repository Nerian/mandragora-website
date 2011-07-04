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
   
  set :public, Proc.new { File.join(File.dirname(__FILE__), '..', '_site') }         
  
  get '/scss/stylesheet.sass' do
    sass :'sass/stylesheet'
  end  
                                                                            
  get '/' do
    File.read('_site/index.html')
  end
  
  get '/blog/*' do
    File.read("_site/#{params[:splat].join}")
  end
     
  ['/proyectos','/equipo','/about'].each do |path|
    get path do
      File.read("_site/#{path}.html")    
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end