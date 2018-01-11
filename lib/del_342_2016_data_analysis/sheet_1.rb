module Del3422016DataAnalysis
  class Sheet1Row < SheetRow
    FULL_SIZE  = 7
    attr_reader :date, :wday, :hour, :zone, :pod, :energy, :cons_type

    def initialize(array, reader=nil)
      if array.size==FULL_SIZE || true # elimino il vincolo =FULLSIZE
        @date, @wday, @hour, @zone, @pod, @cons_type, @energy = array
        @date = parse_date(@date)
        @pod="Undefined" if @pod.nil?
        @pod.strip!
        @cons_type="Undefined" if @cons_type.nil?
        @cons_type.strip!
        @energy = @energy.to_f
      else
        # TODO
      end
    end

    def to_a
      [@date.strftime("%d/%m/%Y"), @wday, @hour, @zone, @pod, @cons_type, @energy]
    end

    def all_empty_values?
      @zone.nil? && @pod.nil? && @cons_type.nil? && @energy.nil?
    end

    def any_empty_value?
      @zone.nil? || @pod.nil? || @cons_type.nil? || @energy.nil?
    end

    def attributes
      [:date, :wday, :hour, :zone, :pod, :cons_type, :energy]
    end
  end
end
