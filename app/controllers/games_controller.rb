require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    if in_grid?(@word, @letters) == false
      @message = "Sorry but #{@word} can't be built out of #{@letters.each { |l| puts l }},"
    elsif in_grid?(@word, @letters) == true && in_dict?(@word) == false
      @message = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @message = "Congratulations! #{@word} is a valid English word!"
    end
    session[:score] = @word.length
  end

  def in_grid?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def in_dict?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
