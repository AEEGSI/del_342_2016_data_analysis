class Array
  def avg
    return nil if self.empty?
    sum = self.reduce(&:+) / self.size
  end

  def arrange(suffix)
    map{|e| File.basename(e, suffix).downcase}.sort
  end
end
