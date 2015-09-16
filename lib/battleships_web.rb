require 'sinatra/base'
require_relative 'board'
require_relative 'cell'
require_relative 'water'
require_relative 'ship'

class BattleshipsWeb < Sinatra::Base

  enable :sessions

  @@board = Board.new(Cell)

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/name_input' do
    erb :name_input
  end

  post '/name_input' do
    session[:name] = params[:name]
    @grid = @@board.show2
    redirect ('/name_input') if params[:name].empty?
    redirect ('/game_play')
  end

  get '/game_play' do
    p session[:name]
    @name = session[:name]
    @cell = params[:cell]
    @grid = @@board.show2
    erb :game_play
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
