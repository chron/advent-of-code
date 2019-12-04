require_relative 'scaffold'

class Day4b < Scaffold
  def run
    lower, upper = input.split(?-).map(&:to_i)

    (lower..upper)
      .map(&:to_s)
      .count { |s| s.length == 6 && s =~ /^#{(0..9).map { |c| "#{c}*" }*''}$/ && s.chars.group_by(&:itself).values.find { |v| v.length == 2 }}
  end
end

__END__
356261-846303
