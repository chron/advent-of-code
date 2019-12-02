module AdventHelpers
  def lines
    input.split("\n")
  end
end

class Scaffold
  include AdventHelpers

  class << self
    def test_case input, expected_output
      @test_cases ||= []
      @test_cases << [input, expected_output]
    end

    def run
      failures = check_test_cases
      puts new(load_data).run if failures.zero?
    end

    def check_test_cases
      @test_cases.each_with_index.count do |(input, expected), index|
        actual = new(input.to_s).run

        if actual.to_s != expected.to_s
          puts "Test case #{index + 1} failed!"
          puts "     Input: #{input}"
          puts "  Expected: #{expected}"
          puts "    Actual: #{actual}"
          puts

          true
        end
      end
    end

    def load_data
      File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
    rescue Errno::ENOENT
      DATA.read rescue ''
    end
  end

  attr_reader :input

  def initialize(input)
    @input = input
  end

  def run
    raise 'Override #run with challenge functionality'
  end
end

at_exit do
  ObjectSpace
    .each_object(Class)
    .select { |c| c < Scaffold }
    .each(&:run)
end
