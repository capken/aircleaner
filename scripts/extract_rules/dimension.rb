
extract :dimension do |input|
  input.each_pair do |label, value|
    if label =~ /产品尺寸/
      if value =~ /(\d+)×(\d+)×(\d+)mm/i
        break {
          'height' => $1.to_i,
          'width' => $2.to_i,
          'deep' => $3.to_i,
        }
      end
    end
  end
end
