module Del3422016DataAnalysis
  class SheetRow
    include ValidateValues

    def join(sep)
      to_a.join(sep)
    end

    def parse_date(date)
      if date=~/\d\d-\d\d-\d\d/
        mdy = date.split("-")
        Date.parse("20#{mdy[2]}-#{mdy[0]}-#{mdy[1]}")
      elsif date=~/\w\w\w-\d\d/
        Date.parse("01-#{date}")
      end
    rescue Exception => e
      nil
    end
  end
end
