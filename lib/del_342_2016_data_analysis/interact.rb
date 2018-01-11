
module Del3422016DataAnalysis

  def ask_for(operator, action)
    print "Do you want to #{action} operator '#{operator}'? (y)es | (N)o | (a)ll | e(x)it ? "
    a = STDIN.gets.chomp
    if a=="y"
      [true, true]
    elsif a=="x"
      puts "Bye!"
      exit
    elsif a=="a"
      [true, false]
    else
      [false, true]
    end
  end
end
