module Del3422016DataAnalysis

  class Operators

    def initialize(operators, xlsx_to_ignore, suffix=".xlsx")
      @suffix = suffix
      if operators==["ALL"]
        @all      = true
        @included = []
        @ignored  = []
      else
        @all      = false
        @included = operators.arrange(@suffix)
        @ignored  = []
      end

      ignore(xlsx_to_ignore)
    end


    def all?
      @all
    end


    def include(list)
      @included = list.arrange(@suffix)
      subtract
    end


    def include?(name)
      @included.include?(name)
    end



    private

    def subtract
      @included.delete_if{|e| @ignored.include?(e)}
    end

    def ignore(xlsx_to_ignore)
      @ignored = xlsx_to_ignore.arrange(@suffix)
      if @ignored.any?
        puts "The following operators will be ignored: #{@ignored.join(', ')}"
      end
      subtract
    end
  end
end
