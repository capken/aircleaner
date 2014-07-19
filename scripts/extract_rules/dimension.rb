
extract :dimension do |input|
  input.each_pair do |label, value|
    if label =~ /^(?:产品|外观)?尺寸/
      dimension = case value
      when /(\d+)[x×*](\d+)[x×*](\d+)(?:mm|毫米)?/i
        dim = [$1, $2, $3].map(&:to_i).sort
        {
          'height' => dim[2],
          'width' => dim[1],
          'deep' => dim[0],
        }
      when /(\d+)[x×*](\d+)[x×*](\d+)（宽X深X高）/i
        {
          'height' => $3.to_i,
          'width' => $1.to_i,
          'deep' => $2.to_i,
        }
      else
        dim = {}
        dim['height'] = $1.to_i if value =~ /高(\d+)/
        dim['width'] = $1.to_i if value =~ /宽(\d+)/
        dim['deep'] = $1.to_i if value =~ /深(\d+)/
        dim
      end
      break dimension
    end
  end
end
