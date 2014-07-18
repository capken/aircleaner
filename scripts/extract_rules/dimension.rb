
extract :dimension do |input|
  input.each_pair do |label, value|
    if label =~ /^产品尺寸(?:\(mm\))?$/
      dimension = case value
      when /(\d+)[×*](\d+)[×*](\d+)mm/i
        dim = [$1, $2, $3].map(&:to_i).sort
        {
          'height' => dim[2],
          'width' => dim[1],
          'deep' => dim[0],
        }
      when /(\d+)X(\d+)X(\d+)（宽X深X高）/i
        {
          'height' => $3.to_i,
          'width' => $1.to_i,
          'deep' => $2.to_i,
        }
      end
      break dimension
    end
  end
end
