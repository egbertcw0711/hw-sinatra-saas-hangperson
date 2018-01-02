class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor:word
  attr_accessor:guesses
  attr_accessor:wrong_guesses

  # Get a word from remote "random word" service
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(char)
    if char == '' or char == nil or !(char =~ /[A-Za-z]/)
      raise ArgumentError
    end
    
    res = false
    if @word.include?(char.downcase)
      if !(@guesses.include?(char.downcase))
        @guesses += char.downcase
        res = true
      end
    else # incorrectly
      if !(@wrong_guesses.include?(char.downcase))
        @wrong_guesses += char.downcase
        res = true
      end
    end
    return res
  end

  def word_with_guesses
    res = @word
    s = ''
    res.split('').each {|c|
      if @guesses.include?(c)
        s += c
      else
        s += '-'
      end
    }
    return s
  end
  
  def check_win_or_lose
    if word_with_guesses == @word
      return :win
    elsif @wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
  end
end
