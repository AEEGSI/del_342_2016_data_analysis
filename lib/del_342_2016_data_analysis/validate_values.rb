module Del3422016DataAnalysis
  module ValidateValues
    def check_no_value(v, s, r)
      raise NoValueException.new("#{s} '#{v}' has no value", r)  if v.nil? || v=="" || v=="-"
    end

    def valid?(attribute: nil, row_number:)
      case attribute
      when nil
        no_value_errors = []
        errors = []
        attributes.each do |a|
          begin
            valid?(attribute: a, row_number: row_number)
          rescue NoValueException => e
            # no_value_errors << e.to_s
            errors << e.to_s
          rescue InvalidValueError => e
            errors << e.to_s
          end
        end
        raise InvalidValueError.new(errors.join(", "), row_number) if errors.any?


      when :date
        raise InvalidValueError.new("date '#{@date}' is invalid", row_number) if !@date.is_a?(Date)


      when :wday
        @wday = @wday.to_i if @wday.is_a?(String)
        raise InvalidValueError.new("wday '#{@wday}' is invalid", row_number) if !(1..7).to_a.include?(@wday)
        raise InvalidValueError.new("wday '#{@wday}' is not correct!", row_number) if @date && (@wday%7)!=@date.wday


      when :hour
        @hour = @hour.is_a?(String) ? @hour.to_i : @hour

        if !@hour.is_a?(Fixnum)
          raise InvalidValueError.new("hour '#{@hour}' is not a number", row_number)
        elsif @hour<1 or @hour>25
          raise InvalidValueError.new("hour '#{@hour}' is invalid", row_number)
        end


      when :zone
        check_no_value(@zone, "zone", row_number)
        raise InvalidValueError.new("zone '#{@zone}' is not a string", row_number) if !@zone.is_a?(String)
        @zone = case @zone.downcase
        when "centro-nord"
          "cnor"
        when "centro nord"
          "cnor"
        when "centro_nord"
          "cnor"
        when "cnord"
          "cnor"
        when "centro-sud"
          "csud"
        when "centro sud"
          "csud"
        when "centro_sud"
          "csud"
        when "sardegna"
          "sard"
        when "sicilia"
          "sici"
        else
          @zone.downcase
        end
        raise InvalidValueError.new("zone '#{@zone}' is invalid", row_number) if !["nord", "cnor", "csud", "sud", "sici", "sard"].include?(@zone)


      when :pod
        # raise InvalidValueError.new("pod '#{@pod}' is not a string", row_number) if !@pod.is_a?(String)
        # raise InvalidValueError.new("pod '#{@pod}' length is invalid", row_number) if @pod.size<9 || @pod.size>15
        @pod = @pod.to_s


      when :cons_type
        raise InvalidValueError.new("consumer type '#{@cons_type}' is not a string", row_number) if !@cons_type.is_a?(String)


      when :energy
        check_no_value(@energy, "energy", row_number)
        raise NoValueException.new("energy '#{@energy}' has no value", row_number)  if @energy.nil? || @energy=="" || @energy=="-"
        @energy = @energy.to_f if @energy.is_a?(String)
        raise InvalidValueError.new("energy '#{@energy}' is not a number", row_number) if !@energy.is_a?(Numeric)


      when :zone_energy
        check_no_value(@zone_energy, "zone_energy", row_number)
        @zone_energy = @zone_energy.to_f if @zone_energy.is_a?(String)
        raise InvalidValueError.new("zone_energy '#{@zone_energy}' is not a number", row_number) if !@zone_energy.is_a?(Numeric)


      when :pod_energy
        check_no_value(@pod_energy, "pod_energy", row_number)
        @pod_energy = @pod_energy.to_f if @pod_energy.is_a?(String)
        raise InvalidValueError.new("pod_energy '#{@pod_energy}' is not a number", row_number) if !@pod_energy.is_a?(Numeric)


      when :tot_energy
        check_no_value(@tot_energy, "tot_energy", row_number)
        @tot_energy = @tot_energy.to_f if @tot_energy.is_a?(String)
        raise InvalidValueError.new("tot_energy '#{@tot_energy}' is not a number", row_number) if !@tot_energy.is_a?(Numeric)
      end
      true
    end
  end
end
