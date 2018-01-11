

module Del3422016DataAnalysis

  class Steps
    STEPS = %w(convert check calculate reduce)

    def initialize(arr)
      if arr==["ALL"]
        @arr = STEPS
      else
        arr = STEPS.dup.keep_if{|e| arr.include?(e)}
        # now fill with steps included between the first and last
        steps_n = (STEPS.index(arr.first)..STEPS.index(arr.last)).to_a
        @arr = steps_n.map{|n| STEPS[n]}
      end
    end

    def each(&block)
      @arr.each{|s| yield(s)}
    end
  end
end
