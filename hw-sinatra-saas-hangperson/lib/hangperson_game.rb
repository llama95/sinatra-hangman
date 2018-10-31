class HangpersonGame
  attr_accessor :word, :guesses, :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = '' #where we will add our guessed chars
    @wrong_guesses = '' # where well put our incorrect guessed chars
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess char
    if char =~ /[[:alpha:]]/ # any aplha character <- cool api find
      char.downcase!
      if @word.include? char and !@guesses.include? char # if the word has the guessed char
                                                         # and guesses doesnt already include the guessed char
        @guesses.concat char #append it to the list
        #puts(@guesses)
        return true
      elsif !@wrong_guesses.include? char and !@word.include? char
        @wrong_guesses.concat char # if wrong guesses doent have the char and the its also not the full word
        #puts(@wrong_guesses) #append it to the wrong guesses
        return true
      else
        return false
      end
    else
      char = :invalid
      raise ArgumentError # raise the arguement if invalid char
    end
  end

  def word_with_guesses
    result = "" #new string
    @word.each_char do |x|  # for every char in the word
      if @guesses.include? x #guesses include the char already
        result.concat x # add char to string
      else
        result.concat '-' #put a hyphen in between
      end
    end
    result
  end


  def check_win_or_lose
    counter = 0
    return :lose if @wrong_guesses.length >= 7 # if they guess 7 wtrong chars
    @word.each_char do |letter| # go through each letter of the random word
      counter += 1 if @guesses.include? letter #increment counter if the guess has a char thats in the word
    end
    if counter == @word.length then :win # if our counter is the same number as the len
    else :play end                        # of the random word... player wins
    #keep playing
  end
end

# test = HangpersonGame.new("glarp")
# test.guess("?")