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

DeckBuilder.build_deck("sample_text.txt")

