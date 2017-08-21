class Pattern
  PATTERNS = ['000', '001', '010', '011', '100', '101', '110', '111']

  def initialize(pattern, locality)
    @pattern = pattern
    length = 2*locality + 1
    @patterns = (2 ** (length)).times.map { |i| i.to_s(2).rjust(length, '0') }
  end

  def on(previous)
    index = @patterns.find_index(previous)
    @pattern[index]
  end
end