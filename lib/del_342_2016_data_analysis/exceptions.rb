module Del3422016DataAnalysis
  class MyStandardError < StandardError
    attr_reader :line
    def initialize(msg, line)
      @line = line
      super(msg)
    end
  end

  class InvalidValueError < MyStandardError
  end

  class NoValueException < MyStandardError
  end
end
