require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    # poopy = puts("FUCK")
    # poop = session[poopy]
    # puts(poop)
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new  # creates the new actoin in our new.erb
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0] # letter guessed in argv0
    begin
    test = @game.guess(letter)
    if not test # if theyve already guessed the letter
      flash[:message] = "You have already used that letter."
    end
  rescue ArgumentError #throw it out
    flash[:message] = "Invalid guess."
  end
    redirect '/show'
  end

  get '/show' do
    ### YOUR CODE HERE ###
    # added for a new git commit cuz i suck
    if @game.check_win_or_lose == :win
      redirect '/win'
    elsif @game.check_win_or_lose == :lose
      redirect '/lose'
    else
      erb :show #winning or losing state
    end # You may change/remove this line
  end

  get '/win' do
    ### YOUR CODE HERE ###
    if @game.check_win_or_lose == :win #winner case
      erb :win
    else
      redirect '/show'
    end
  end

  get '/lose' do
    ### YOUR CODE HERE ###
    if @game.check_win_or_lose == :lose # who wins
      erb :lose # You may change/remove this line
    else
      redirect '/show'
    end
  end

end
