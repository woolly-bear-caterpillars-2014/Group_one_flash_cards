
require "pry"

class Controller
attr_accessor :card, :deck, :current_session, :view
  def initialize 
    @view = View.new
    #@deck = Deck.new
    run
  end
  def run
    
    view.show_card
    view.display_prompt 
    
    until view.get_input==deck.card.answer
        view.wrong_answer
    end
    
    view.right_answer
  
  #if deck.length==0 || view.get_input=="quit"
    view.game_over
    end 
  #end

end

class View
  WRONGANSWERS=["I don't have the time or the crayons to explain it to you.", "Did your parents ever ask you to run away from home?", "If you were any more stupid, you'd have to be watered once a week.", "A demitasse would fit your head like a sombrero.", "You have one brain cell and it's fighting for domination.", "I had a nightmare. I dreamt I was you.", "I know you're nobody's fool, but maybe someone will adopt you.", "Ordinary people live and learn. You just live.", "If what you know can't hurt you, you're practically invincible.", "Keep talking, someday you'll say something intelligent.", "You're a habit I'd like to kick with both feet.", "You're like one of those idiot savants, except without the 'savant' part.", "You're the best at all you do! And all you do is make people hate you.", "You remind me of the ocean. You make me sick.", "A halfwit gave you a piece of his mind and you held onto it.", "Don't let your mind wander. It's way too small to be outside by itself.", "Earth is full. Go home.", "I bet your brain feels as good as new seeing as you've never used it.", "Your brain waves fall a little short of the beach.", "That's it. No more free will.", "If I throw a stick, will you leave?"]

  

  def initialize
    welcome_to_flashcards
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
    puts "Sample card from deck"
   # puts deck.sample.definition
  end

  def wrong_answer
    puts WRONGANSWERS.sample
  end

  def right_answer
    puts "Bravo."
  end

  def game_over
    puts "Game over! Do you want to play again?"
  end
end 

binding.pry