
# require "pry"
require "prettyprint"
require "colorize"
require "asciiart"

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
  attr_accessor :cards

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

  def initialize(quiz)
    @view = View.new(quiz)
    run
  end

  def run

    until view.deck.cards.length==0
    view.show_card
    view.display_prompt
    count=0
    answer = view.get_input
      until answer==view.current_card.answer || count==2
        view.deck.cards = [] if answer == "quit"
        break if answer == "quit"
          view.wrong_answer
          count+=1
          answer = view.get_input
          end

    if count==2
      view.show_answer
    else
      view.right_answer unless answer == "quit"
    end

    end

    view.game_over
  end
end

class View
  attr_accessor :deck, :current_card
  WRONGANSWERS=["I don't have the time or the crayons to explain it to you.", "Did your parents ever ask you to run away from home?", "If you were any more stupid, you'd have to be watered once a week.", "A demitasse would fit your head like a sombrero.", "You have one brain cell and it's fighting for domination.", "I had a nightmare. I dreamt I was you.", "I know you're nobody's fool, but maybe someone will adopt you.", "Ordinary people live and learn. You just live.", "If what you know can't hurt you, you're practically invincible.", "Keep talking, someday you'll say something intelligent.", "You're a habit I'd like to kick with both feet.", "You're like one of those idiot savants, except without the 'savant' part.", "You're the best at all you do! And all you do is make people hate you.", "You remind me of the ocean. You make me sick.", "A halfwit gave you a piece of his mind and you held onto it.", "Don't let your mind wander. It's way too small to be outside by itself.", "Earth is full. Go home.", "I bet your brain feels as good as new seeing as you've never used it.", "Your brain waves fall a little short of the beach.", "That's it. No more free will.", "If I throw a stick, will you leave?"]

  INSULTS=["Moron", "Dimwit", "Dingbat", "Imbecile", "Halfwit", "Dullard", "Dolt", "Twit", "Weakling"]


  def initialize(quiz)
    welcome_to_flashcards
    @deck=DeckBuilder.build_deck(quiz)

  end

  def welcome_to_flashcards
    puts "\e[2J"

    puts "\n\n          WELCOME TO\n           QUIZZILA\n             BY\n           CRUELLA\n\n".colorize(:light_yellow).on_light_blue

    # puts "  ____        _         _ _ _           _                _____                 _ _        "
    # puts " / __ \      (_)       (_) | |         | |              / ____|               | | |       "
    # puts "| |  | |_   _ _ _________| | | __ _    | |__  _   _    | |     _ __ _   _  ___| | | __ _  "
    # puts "| |  | | | | | |_  /_  / | | |/ _` |   | '_ \| | | |   | |    | '__| | | |/ _ \ | |/ _` | "
    # puts "| |__| | |_| | |/ / / /| | | | (_| |   | |_) | |_| |   | |____| |  | |_| |  __/ | | (_| | "
    # puts " \___\_\\__,_|_/___/___|_|_|_|\__,_|   |_.__/ \__, |    \_____|_|   \__,_|\___|_|_|\__,_| "
    # puts "                                               __/ |                                      "
    # puts "                                              |___/                                       "
  end

  def get_input
    gets.chomp
  end

  def display_prompt
    puts "\n\n          I bet you don't know the answer!\n".colorize(:light_blue).on_light_yellow
  end

  def show_card
    @current_card=deck.cards.sample
    deck.cards.delete_if { |card| card==current_card}
    puts "\n\n#{current_card.definition}\n\n".colorize(:red).on_light_yellow
  end

  def show_answer
    puts "\n\n          #{INSULTS.sample}. The correct answer is #{current_card.answer}.\n\n".colorize(:black).on_green
  end

  def wrong_answer
    puts "\n\n          #{WRONGANSWERS.sample.upcase}\n\n".colorize(:light_yellow).on_light_blue
    puts "\n\n          GUESS AGAIN!\n".light_yellow.on_red.blink
    puts "\n"
  end

  def right_answer
    puts "\n\n          Bravo.\n\n".colorize(:light_yellow).on_light_blue
  end

  def game_over

    puts "\e[2J"
    puts "\n\n          THANK GOD!\n            NO ONE\n          WANTS YOU\n           TO PLAY\n            AGAIN\n\n".colorize(:light_yellow).on_light_blue.blink
    puts "\n" * 12

    #        puts   "_________                  _                      _    "
    #        puts   "|__   __|                 | |                    | |   "
    #        puts   "   | |  | |__   __ _ _ __ | | __   __ _  ___   __| |   "
    #        puts   "   | |  | '_ \ / _` | '_ \| |/ /  / _` |/ _ \ / _` |   "
    #        puts   "   | |  | | | | (_| | | | |   <  | (_| | (_) | (_| |_  "
    #        puts   "   |_|  |_| |_|\__,_|_| |_|_|\_\  \__, |\___/ \__,_(_) "
    #        puts   "                                   __/ |               "
    #        puts   "                                   |___/               "

    # puts "   _   _       _               _                             _          "
    # puts "  | \ | |     | |             | |                           | |         "
    # puts "  |  \| | ___ | |__   ___   __| |_   _    __      ____ _ _ __ | |_ ___  "
    # puts "  | . ` |/ _ \| '_ \ / _ \ / _` | | | |   \ \ /\ / / _` | '_ \| __/ __| "
    # puts "  | |\  | (_) | |_) | (_) | (_| | |_| |   \ V  V | (_| | | | | |_\__ \  "
    # puts "  |_| \_|\___/|_.__/ \___/ \__,_|\__, |   \_/\_/ \__,_|_| |_|\__|___/   "
    # puts "                                 __/  |                                 "
    # puts "                                 |___/                                  "

    #                       puts " __     ______  _    _   "
    #                       puts " \ \   / / __ \| |  | |  "
    #                       puts "  \ \_/ | |  | | |  | |  "
    #                       puts "   \   /| |  | | |  | |  "
    #                       puts "    | | | |__| | |__| |  "
    #                       puts "    |_|  \____/ \____/   "

    #     puts "   _                _                                 _          "
    #     puts "  | |              | |                               (_)         "
    #     puts "  | |_ ___    _ __ | | __ _ _   _    __ _  __ _  __ _ _ _ __     "
    #     puts "  | __/ _ \  | '_ \| |/ _` | | | |  / _` |/ _` |/ _` | | '_ \    "
    #     puts "  | || (_) | | |_) | | (_| | |_| | | (_| | (_| | (_| | | | | |_  "
    #     puts "   \__\___/  | .__/|_|\__,_|\__, |  \__,_|\__, |\__,_|_|_| |_(_) "
    #     puts "             | |             __/ |         __/ |                 "
    #     puts "             |_|            |___/         |___/                  "


  end
end

Controller.new("release_two.txt")
# binding.pry
