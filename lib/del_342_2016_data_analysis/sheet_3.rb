module Del3422016DataAnalysis
  class Sheet3Row < SheetRow
    FULL_SIZE  = 6
    attr_reader :date, :zone, :pod, :zone_energy, :pod_energy

    def initialize(array, reader=nil)
      if array.size==FULL_SIZE || true # elimino il vincolo =FULLSIZE
        @date, @zone, @pod, @cons_type, @zone_energy, @pod_energy = array
        @date = parse_date(@date)
        @pod="Undefined" if @pod.nil?
        @pod.to_s.strip!
        @cons_type="Undefined" if @cons_type.nil?
        @cons_type.strip!
        @reader = reader
        @zone_energy = @zone_energy.to_f
        @pod_energy = @pod_energy.to_f
      else
        # TODO
      end
    end

    def to_a
      [@date.strftime("%m/%Y"), @zone, @pod, @cons_type, @zone_energy, @pod_energy]
    end

    def all_empty_values?
      @zone.nil? && @pod.nil? && @cons_type.nil? && @zone_energy.nil?
    end

    def any_empty_value?
      @zone.nil? || @pod.nil? || @cons_type.nil? || @zone_energy.nil?
    end

    def attributes
      [:date, :zone, :pod, :cons_type, :zone_energy, :pod_energy]
    end
  end
end
