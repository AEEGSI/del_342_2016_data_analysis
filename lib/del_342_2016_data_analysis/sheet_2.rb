module Del3422016DataAnalysis
  class Sheet2Row < Sheet1Row
    FULL_SIZE  = 6

    # ATTRIBUTES = [:date, :wday, :hour, :zone, :pod, :cons_type, :energy]

    def initialize(array, reader=nil)
      if array.size==FULL_SIZE || true # elimino il vincolo =FULLSIZE
        date, wday, hour, zone, pod, energy = array
        cons_type = "Servizi Ausiliari"
        super([date, wday, hour, zone, pod, "Servizi Ausiliari", energy], reader)
      else
        # TODO
      end
    end
  end
end
