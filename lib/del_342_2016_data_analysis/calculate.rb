module Del3422016DataAnalysis

  def calculate(dir, base_path, logger)
    op = dir[:operator]
    dat_files_path = Folders.dat_path(base_path)
    logger.info "Parsing csv files of '#{dir[:operator]}' (#{dir[:path]})"


    Dir.glob(File.join(dir[:path], "*.csv")) do |csv_file|
      filename = File.basename(csv_file)
      logger.info "  - #{filename}"
      errors = ErrorAggregator.new

      line = 1
      rows = []
      append = false
      add_column = nil

      case filename
      when /^Curve di Prelievo Orarie AT_SA/i
        sheet_row_class = Sheet2Row
        header = []
        output_filename = "UCDataATOrari.dat"
        append = true
        add_column = 0.0

      when /^Curve di Prelievo Orarie AT/i
        sheet_row_class = Sheet1Row
        header = %w{data Giorno_settimana Ora Zona_Elettrica POD Tipo_Utenza Energia_Prelevata_MWh Energia_biddata_esitoMI_MWh }
        output_filename = "UCDataATOrari.dat"
        add_column = 0.0

      when /^ValoriMensili AT/i
        sheet_row_class = Sheet3Row
        header = %w{ Data Zona_Elettrica  POD Tipo_Utenza Energia_totale_prelevata_Zona_z_MWw Energia_Prelevata_POD_MWh } # Energia_biddata_esitoMI_MWh
        output_filename = "UCDataATMensili.dat"

      when /^ValoriMensili MT/i
        sheet_row_class = Sheet456Row
        header = ["Data", "Zona_Elettrica", "Energia_totale_prelevata_Zona_z_MWw", "Energia_Prelevata_Zona_z_(Valore Aggregato)_MWh"]
        output_filename = "UCDataMTMensili.dat"

      when /^ValoriMensili BT Domestico/i
        sheet_row_class = Sheet456Row
        header = ["Data", "Zona_Elettrica", "Energia_totale_prelevata_Zona_z_MWw", "Energia_Prelevata_Zona_z_(Valore Aggregato)_MWh"]
        output_filename = "UCDataBTDMensili.dat"

      when /^ValoriMensili BT Altri Usi/i
        sheet_row_class = Sheet456Row
        header = ["Data", "Zona_Elettrica", "Energia_totale_prelevata_Zona_z_MWw", "Energia_Prelevata_Zona_z_(Valore Aggregato)_MWh"]
        output_filename = "UCDataBTAUMensili.dat"

      else
        logger.error "---!!! #{operator}/#{filename} sheet name has no match!"
        next
      end

      CSV.foreach(csv_file) do |row|
        if row[0]
          if row[0]=~/\d\d-\d\d-\d\d/ || row[0]=~/\w\w\w-\d\d/ # "07-31-16" or "Jan-17"
            sheet_row = sheet_row_class.new(row)
            if sheet_row.all_empty_values?
              errors.add("Empty row", line)
            else
              begin
                sheet_row.valid?(row_number: line)
                rows << sheet_row
              rescue InvalidValueError => e
                errors.add(e.to_s, line)
              end
            end
          end
        end
        # use row here...
        line += 1
      end
      errors.each do |e|
        logger.error "#{e.msg} (rows: #{e.grouped_lines})"
      end
      sheet = OpenStruct.new(header: header, rows: rows, size: rows.size, filename: output_filename, operator: op, sheet_name: filename)
      save_to_dat(path: dat_files_path, sheet: sheet, logger: logger, append: append, add_column: add_column)
    end
    run_julia(File.join(dat_files_path, op), logger)

  end


  def save_to_dat(path:, sheet:, logger:, append: false, add_column: nil)
    logger.info "   ...saving data for #{sheet.operator}, sheet name #{sheet.sheet_name} to disk..."
    Dir.mkdir(File.join(path, sheet.operator)) if !Dir.exists?(File.join(path, sheet.operator))

    File.open(File.join(path, sheet.operator, sheet.filename), append ? 'a' : 'w') do |file|
      file.write(sheet.header.join("\t")+"\n") if !append
      sheet.rows.each do |row|
        rs = row.to_a
        rs << add_column if !add_column.nil?
        result = rs.join("\t")+"\n"
        file.write(result)
      end
    end
  end

end
