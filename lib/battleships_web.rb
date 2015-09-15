require 'sinatra/base'

class BattleshipsWeb < Sinatra::Base

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/name_input' do
    @name = params[:name]
    erb :name_input
  end

  get '/game' do
    @name = params[:name]
    erb :game
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
