class Log
  def self.debug_mode
    @@debug_mode
  end

  def self.debug_mode=(val)
    @@debug_mode = val
  end

  def self.debug(msg)
    log(msg, true)
  end

  def self.output(msg)
    log(msg, false)
  end

  def self.log(msg, debug = true)
    if debug && debug_mode
      puts msg
    elsif !debug
      puts msg
    end
  end
end