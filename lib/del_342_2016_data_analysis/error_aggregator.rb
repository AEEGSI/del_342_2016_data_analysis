module Del3422016DataAnalysis
  class ErrorAggregator

    class OneError
      attr_reader :msg
      attr_accessor :lines

      def initialize(msg, line)
        @msg = msg
        @lines = [line]
      end

      def grouped_lines
        prev_e = nil
        arr = []
        a = []
        while e = @lines.shift
          if prev_e
            if e==(prev_e+1)
              a << e
              # prev_e = e
            else
              arr << a
              a = [e]
            end
          else
            a = [e]
          end
          prev_e = e
        end

        arr << a if !a.empty?

        arr.map do |a|
          if a.size==1
            a.first.to_s
          else
            "#{a[0]}-#{a[-1]}"
          end
        end.join(", ")
      end
    end




    def initialize
      @array = []
    end

    def add(msg, line)
      if @array.last
        if @array.last.msg==msg
          @array.last.lines << line
        else
          @array << OneError.new(msg, line) #{ msg: msg, lines: [line]}
        end
      else
        @array << OneError.new(msg, line) #{ msg: msg, lines: [line]}
      end
    end

    def each(&block)
      if block_given?
        @array.each do |e|
          yield(e)
        end
      end

    end
  end
end
