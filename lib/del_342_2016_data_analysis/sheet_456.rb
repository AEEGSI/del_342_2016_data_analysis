module Del3422016DataAnalysis
  class Sheet456Row < SheetRow
    FULL_SIZE  = 4
    attr_reader :date, :zone, :tot_energy, :energy

    def initialize(array, reader=nil)
      if array.size==FULL_SIZE || true # elimino il vincolo =FULLSIZE
        @date, @zone, @tot_energy, @energy = array
        @date = parse_date(@date)
        @reader = reader
        @tot_energy = @tot_energy.to_f
        @energy = @energy.to_f
      else
        # TODO
      end
    end

    def to_a
      [@date.strftime("%m/%Y"), @zone, @tot_energy, @energy]
    end

    def all_empty_values?
      @zone.nil? && @tot_energy.nil? && @energy.nil?
    end

    def any_empty_value?
      @zone.nil? || @tot_energy.nil? || @energy.nil?
    end

    def attributes
      [:date, :zone, :tot_energy, :energy]
    end
  end
end
