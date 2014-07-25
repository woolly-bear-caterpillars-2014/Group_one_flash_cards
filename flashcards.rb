
require "pry"

module DeckBuilder

  def self.read_file(filename)
    file = File.open(filename, "r").read
    parse_data(file.split("\n"))
  end


  def self.parse_data(raw_card_data)
  definitions = []
  answers = []
  raw_card_data.reject! {|line| line.empty? }
  raw_card_data.each_with_index do |line, i|
    definitions << line if i % 2 == 0
    answers << line if i % 2 != 0
  end
  data = definitions.zip(answers)
  end

  def self.build_deck(filename)
    data = read_file(filename)
    Deck.new(data.map {|pair| Card.new(pair[0], pair[1]) })
  end

end

class Deck
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

end


class Card
  attr_reader :answer, :definition

  def initialize (definition, answer)
    @definition = definition
    @answer = answer
  end

  def to_s
    "#{answer}, #{definition}"
  end
end

#DeckBuilder.build_deck("sample_text.txt")

class Controller
attr_accessor :card, :current_session, :view
  def initialize 
    @view = View.new
    run
  end
  def run
    
    until view.deck.cards.length==0 
    view.show_card
    view.display_prompt 
    count=0
      until view.get_input==view.current_card.answer || count==3
          view.wrong_answer
          count+=1
      end
      
    unless count==3 
      view.right_answer
    end
    end
    view.game_over
  end
end

class View
  attr_accessor :deck, :current_card
  WRONGANSWERS=["I don't have the time or the crayons to explain it to you.", "Did your parents ever ask you to run away from home?", "If you were any more stupid, you'd have to be watered once a week.", "A demitasse would fit your head like a sombrero.", "You have one brain cell and it's fighting for domination.", "I had a nightmare. I dreamt I was you.", "I know you're nobody's fool, but maybe someone will adopt you.", "Ordinary people live and learn. You just live.", "If what you know can't hurt you, you're practically invincible.", "Keep talking, someday you'll say something intelligent.", "You're a habit I'd like to kick with both feet.", "You're like one of those idiot savants, except without the 'savant' part.", "You're the best at all you do! And all you do is make people hate you.", "You remind me of the ocean. You make me sick.", "A halfwit gave you a piece of his mind and you held onto it.", "Don't let your mind wander. It's way too small to be outside by itself.", "Earth is full. Go home.", "I bet your brain feels as good as new seeing as you've never used it.", "Your brain waves fall a little short of the beach.", "That's it. No more free will.", "If I throw a stick, will you leave?"]

  

  def initialize
    welcome_to_flashcards
    @deck=DeckBuilder.build_deck("sample_text.txt")

  end

  def welcome_to_flashcards
    puts "Welcome!"
  end

  def get_input
    gets.chomp
  end

  def display_prompt
    puts "What word corresponds with this definition?"
  end

  def show_card
    @current_card=deck.cards.sample
    deck.cards.delete_if { |card| card==current_card}
    puts current_card.definition
  end

  def wrong_answer
    puts WRONGANSWERS.sample + " Guess again."
  end

  def right_answer
    puts "Bravo."
  end

  def game_over
    puts "Game over! Do you want to play again?"
  end
end 

binding.pry