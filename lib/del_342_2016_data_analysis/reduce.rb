require 'axlsx'

module Del3422016DataAnalysis


  def get_months(year)
    months = []
    (1..12).to_a.each{|m| months << "#{m.to_s.rjust(2, '0')}/#{year}"}
    (1..7).to_a.each{|m| months << "#{m.to_s.rjust(2, '0')}/#{year+1}"}
    months
  end


  def format_month(string, mesi)
    a = string.split("/")
    "#{mesi[a[0].to_i]}-#{a[1][2..3]}"
  end

  def format_number(number, use_comma_as_decimal_sep)
    if use_comma_as_decimal_sep
      number.to_s.gsub(".", ",")
    else
      number
    end
  end


  def reduce(dat_dirs, base_path, year, logger)
    months = get_months(year)
    zones = {"nord" => "Nord", "cnor" => "Centro Nord", "csud" => "Centro Sud", "sard" => "Sardegna", "sici" => "Sicilia", "sud" => "Sud"}
    mesi  = Hash[%w(gen feb mar apr mag giu lug ago set ott nov dic).map.with_index{|e,i| [i+1,e]}]
    use_comma_as_decimal_sep = true
    results_path = Folders.results_path(base_path)


    # hh = disp_files.map{|f| OpenStruct.new(path: f, operator: f.split("/")[-2].strip)}

    Axlsx::Package.new do |p|
      # styles
      percent_style = p.workbook.styles.add_style(:num_fmt => Axlsx::NUM_FMT_PERCENT)
      month_style   = p.workbook.styles.add_style(:b => true)

      dat_dirs.each do |disp_dir|
        disp_file = File.join(disp_dir[:path], "Disp.dat")
        op = disp_dir[:operator]
        if File.exists?(disp_file)
          puts "reading #{disp_file}"
          File.open(disp_file) do |f|
            idx = 0
            hash = {}
            f.each_line do |line|
              if idx>0
                cells = line.split("\t").map{|e| e[1...-1]}

                month = cells[0]  # "01/2015"
                zone  = cells[1]  # "csud"
                disp  = 0.30 + cells[2].to_f   # "0.25759072497735636"
                # disp = disp*100.0
                hash[[month,zone]] = disp
                # puts "month: #{month} - zone: #{zone} - disp: #{disp}"
              end
              idx+=1
            end

            # Write to Excel file
            p.workbook.add_worksheet(name: op[0..30]) do |sheet|
              sheet.add_row [""]+zones.values, style: [nil, month_style, month_style, month_style, month_style, month_style, month_style]
              months.each do |month|
                row = []
                row << format_month(month, mesi)
                zones.each_pair do |zone_code, zone_name|
                  c = hash[[month,zone_code]]
                  if c
                    row << format_number(c, false)
                  else
                    row << "" # siamo sicuri ???????
                  end
                end
                sheet.add_row row, style: [month_style, percent_style, percent_style, percent_style, percent_style, percent_style, percent_style]
              end
            end


            # Write to txt files
            filepath = File.join(results_path, "#{op}.txt")
            puts "writing in #{filepath}"
            File.open(filepath, 'w') do |file|
              file.write(([""]+zones.values).join("\t")+"\n") # intestazione con le zone
              months.each do |month|
                row = []
                row << format_month(month, mesi)
                zones.each_pair do |zone_code, zone_name|
                  c = hash[[month,zone_code]]
                  if c
                    row << format_number(c, use_comma_as_decimal_sep)
                  else
                    row << "" # siamo sicuri ???????
                  end
                end
                file.write(row.join("\t")+"\n")
              end
            end
          end
        else
          logger.alert "'#{disp_file}' not found!"
        end


        p.serialize(File.join(results_path, "Tutti gli operatori.xlsx"))
      end
    end
  end
end
