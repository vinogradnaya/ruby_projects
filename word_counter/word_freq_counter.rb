class LineEvaluator

  #  max_count - a max number of occurences of a single word in a line
  #  max_words - an array of words that occur max number of times in a line
  #  line_content - the contents of the evaluated line (string)
  #  line_number  - the number of the evaluated line in the text
  attr_reader :max_count, :max_words, :line_content, :line_number

  #  takes a line of text and a line number & calculated the words frequency
  def initialize (line_content, line_number)
    @line_content = line_content
    @line_number = line_number
    @max_words = []
    calculate_max_word_count()
  end

  #  calculates the maximum number of encounters of a single word within
  #  provided line_content and stores that in the max_count attribute.
  #  identifies the words that were used the maximum number of times and
  #  stores that in the max_words attribute.
  def calculate_max_word_count()
    word_frequency = Hash.new(0)
    @line_content.split.each do |word| 
      word_frequency[word.downcase] += 1 
    end
    @max_count = word_frequency.values.max
    word_frequency.each { |k, v| @max_words << k if v == @max_count }
  end
end

class Solver
  include Enumerable

  #  evaluators - an array of LineEvaluator objects (for each line in the file)
  #  max_count_in_text - a number with the maximum value for max_words attribute in the evaluators array.
  #  max_words_in_text - a filtered array of LineEvaluator objects with the max_words attribute 
  #  equal to the max_count_in_text determined previously.
  attr_reader :evaluators, :max_count_in_text, :max_words_in_text

  def initialize()
    @evaluators = []
  end

  #  processes 'test.txt' intro an array of LineEvaluators and stores them in evaluators.
  def evaluate_file()
    line_count = 0
    File.foreach('test.txt') do |line|
      line_evaluator = LineEvaluator.new(line, line_count)
      @evaluators << line_evaluator
      line_count +=1
    end
  end

  #  determines the max_count_in_text and 
  #  max_words_in_text attribute values
  def calculate_max_word_count_in_text()
    @max_count_in_text = @evaluators.max_by{ |line_evaluator| line_evaluator.max_count }
                                            .max_count
    @max_words_in_text = self.select {|line_evaluator| line_evaluator.max_count == @max_count_in_text }
  end

  #  prints the values of LineEvaluator objects in 
  #  max_words_in_text in the specified format
  def print_max_words_in_text()
    puts "The following words have the max count per line:"
    @max_words_in_text.each do |line_evaluator|
      puts "#{line_evaluator.max_words} (appears in line #{line_evaluator.line_number})"
    end
  end

  def each 
    @evaluators.each { |line_evaluator| yield line_evaluator }
  end 
end
