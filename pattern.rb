class Pattern
  PATTERNS = ['000', '001', '010', '011', '100', '101', '110', '111']
  def initialize(pattern)
    @pattern = pattern
  end

  def on(previous)
    index = PATTERNS.find_index(previous)
    @pattern[index]
  end
end