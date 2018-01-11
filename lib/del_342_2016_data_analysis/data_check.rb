module Del3422016DataAnalysis

  def check_data(f, operator, logger)
    logger.info "\nParsing csv files of '#{operator}' (#{f})"
    sheets_collection = Array.new(6, nil)

    Dir.glob(File.join(f, "*.csv")) do |csv_file|
      filename = File.basename(csv_file)
      logger.info "  - #{filename}"
      # errors = ErrorAggregator.new

      line = 1
      rows = []
      append = false
      add_column = nil

      sheet_row_class, sheets_index = detect_sheet(filename, logger)
      next if sheet_row_class.nil?

      CSV.foreach(csv_file) do |row|
        if row[0]
          if row[0]=~/\d\d-\d\d-\d\d/ || row[0]=~/\w\w\w-\d\d/ # "07-31-16" or "Jan-17"
            sheet_row = sheet_row_class.new(row)
            if sheet_row.all_empty_values?
              # errors.add("Empty row", line)
            else
              begin
                sheet_row.valid?(attribute: :zone, row_number: line)
                rows << sheet_row
              rescue InvalidValueError => e
                # errors.add(e.to_s, line)
              rescue NoValueException => e
              end
            end
          end
        end
        # use row here...
        line += 1
        sheets_collection[sheets_index] = rows
      end
    end
    logger.info "\n"

    if sheets_collection.compact.size == 6
      # ha letto tutti i 6 file
      at_h = {}  # dato orario AT   v(ora, zona, POD)
      at_m = {}  # dato mensile AT, v(mese, zona, POD)
      at_zn = {} # dato mensile, v(mese, zona), energia prel. totale
      mt_m  = {} # dato mensile BT, v(mese, zona)
      mt_zn = {}  # dato mensile, v(mese, zona), energia prel. totale
      bt_dom_m  = {}
      bt_dom_zn = {}
      bt_au_m  = {}
      bt_au_zn = {}

      # pp sheets_collection[0]
      threshold = 0.1
      ratio_threshold = 1e-5

      sheets_collection[0].each do |r|
        key = "#{r.date.strftime('%Y%m')}-#{r.zone}"
        at_h[key] ||= 0.0
        at_h[key] += r.energy
      end

      sheets_collection[1].each do |r|
        key = "#{r.date.strftime('%Y%m')}-#{r.zone}"
        at_h[key] ||= 0.0
        at_h[key] += r.energy
      end

      sheets_collection[2].each do |r|
        key = "#{r.date.strftime('%Y%m')}-#{r.zone}"
        at_m[key] ||= 0.0
        at_m[key] += r.pod_energy
        (at_zn[key]||=[]) << r.zone_energy
      end

      sheets_collection[3].each do |r|
        key = "#{r.date.strftime('%Y%m')}-#{r.zone}"
        mt_m[key] ||= 0.0
        mt_m[key] += r.energy
        (mt_zn[key]||=[]) << r.tot_energy
      end

      sheets_collection[4].each do |r|
        key = "#{r.date.strftime('%Y%m')}-#{r.zone}"
        bt_dom_m[key] ||= 0.0
        bt_dom_m[key] += r.energy
        (bt_dom_zn[key]||=[]) << r.tot_energy
      end

      sheets_collection[5].each do |r|
        key = "#{r.date.strftime('%Y%m')}-#{r.zone}"
        bt_au_m[key] ||= 0.0
        bt_au_m[key] += r.energy
        (bt_au_zn[key]||=[]) << r.tot_energy
      end


      # Sommo tutti i valori orari in AT presenti in:
      # - Curve di Prelievo Orarie AT
      # - Curve di Prelievo Orarie AT_SA
      # aggregati per mese e POD.
      # Devono coincidere con la somma presente in ValoriMensili AT.
      logger.info "Checking AT-h vs AT-m: they should match!"
      yyyymmzn = (at_h.keys+at_m.keys).uniq
      logger.info "  found #{yyyymmzn.size} yyyymm-zn"
      has_errors = false
      yyyymmzn.each do |k|
        if at_h[k].nil? || at_m[k].nil?
          logger.info "  Something is nil for #{k}: h: #{at_h[k].round(3) rescue 'nil'}, m: #{at_m[k].round(3) rescue 'nil'}"
        else
          if at_h[k]-at_m[k]>threshold
            if (at_h[k]-at_m[k])/at_h[k]>1e-5
              logger.info "  No match for #{k}: h: #{at_h[k].round(3)}, m: #{at_m[k].round(3)}"
              has_errors = true
            else
              logger.info "  Not exact sum for #{k}: h: #{at_h[k].round(3)}, m: #{at_m[k].round(3)}"
            end
          end
        end
      end
      logger.info "OK!!!" unless has_errors

      logger.info "\nChecking AT-zn: they should all have the same value!"
      # logger.info at_zn
      has_errors = false
      at_zn.each_pair do |yyyymmzn, arr|
        if arr.uniq.size>1
          logger.info "  #{yyyymmzn} has multiple values: #{p_array(arr)}"
          has_errors = true
        end
      end
      logger.info "OK!!!" unless has_errors


      logger.info "\nChecking MT-zn: they should all have the same value!"
      # logger.info at_zn
      has_errors = false
      mt_zn.each_pair do |yyyymmzn, arr|
        if arr.uniq.size>1
          logger.info "  #{yyyymmzn} has multiple values: #{p_array(arr)}"
          has_errors = true
        end
      end
      logger.info "OK!!!" unless has_errors


      logger.info "\nChecking BT-dom-zn: they should all have the same value!"
      # logger.info at_zn
      has_errors = false
      bt_dom_zn.each_pair do |yyyymmzn, arr|
        if arr.uniq.size>1
          logger.info "  #{yyyymmzn} has multiple values: #{p_array(arr)}"
          has_errors = true
        end
      end
      logger.info "OK!!!" unless has_errors


      logger.info "\nChecking BT-au-zn: they should all have the same value!"
      # logger.info at_zn
      has_errors = false
      bt_au_zn.each_pair do |yyyymmzn, arr|
        if arr.uniq.size>1
          logger.info "  #{yyyymmzn} has multiple values: #{p_array(arr)}"
          has_errors = true
        end
      end
      logger.info "OK!!!" unless has_errors


      logger.info "\nChecking all yyyymm-zn together: they should all have the same value!"
      keys = (at_zn.keys + mt_zn.keys + bt_dom_zn.keys + bt_au_zn.keys).uniq
      has_errors = false
      keys.each do |k|
        arr = at_zn.fetch(k, []) + mt_zn.fetch(k, []) + bt_dom_zn.fetch(k, []) + bt_au_zn.fetch(k, [])
        if arr.map{|n| n.round(1)}.uniq.size>1
          avg = arr.avg
          if avg && arr.all?{|e| (e-avg).abs/e < 1e-5}
            logger.info "  values for #{k} are almost equal (#{arr.uniq.join(', ')})"
          else
            logger.info "  #{k} has multiple values (#{arr.uniq.map{|e| e.round(3)}.join(', ')})"
            has_errors = true
          end
        end
      end
      logger.info "OK!!!" unless has_errors

      logger.info "\nChecking sum of prelievi together: they should all have the same value!"
      has_errors = false
      keys.each do |k|
        arr = at_zn.fetch(k, []) + mt_zn.fetch(k, []) + bt_dom_zn.fetch(k, []) + bt_au_zn.fetch(k, [])
        sum = at_m.fetch(k, 0.0) + mt_m.fetch(k, 0.0) + bt_dom_m.fetch(k, 0.0) + bt_au_m.fetch(k, 0.0)
        wrt_sum = arr.uniq.first
        if ((wrt_sum-sum).abs/sum)>ratio_threshold
          logger.info "  No match for #{k}: written sum: #{wrt_sum.round(3)}, calculated sum: #{sum.round(3)}"
          has_errors = true
        end
      end
      logger.info "OK!!!" unless has_errors


      # pp at_h
      # pp at_m
      # pp at_zn
      # pp mt_m
      # pp mt_zn
      # pp bt_dom_m
      # pp bt_dom_zn
      # pp bt_au_m
      # pp bt_au_zn
    end
  end



  def p_array(arr)
    s = arr.map{|e| e.nil? ? "nil" : e.round(3)}.join(", ")
    "[#{s}]"
  end


  def detect_sheet(filename, logger)
    case filename
    when /^Curve di Prelievo Orarie AT_SA/i
      sheet_row_class = Sheet2Row
      sheets_index = 1

    when /^Curve di Prelievo Orarie AT/i
      sheet_row_class = Sheet1Row
      sheets_index = 0

    when /^ValoriMensili AT/i
      sheet_row_class = Sheet3Row
      sheets_index = 2

    when /^ValoriMensili MT/i
      sheet_row_class = Sheet456Row
      sheets_index = 3

    when /^ValoriMensili BT Domestico/i
      sheet_row_class = Sheet456Row
      sheets_index = 4

    when /^ValoriMensili BT Altri Usi/i
      sheet_row_class = Sheet456Row
      sheets_index = 5

    else
      logger.error "---!!! #{operator}/#{filename} sheet name has no match!"
      return nil
    end
    [sheet_row_class, sheets_index]
  end


end
