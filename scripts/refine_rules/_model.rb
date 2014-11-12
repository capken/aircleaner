refine do |record|
  model = record['model']
  if model.nil?
    @is_good_record = false
    next
  end

  model = model.gsub(/（.*?）/, ' ')

  case record['brand']
  when /^3M$/
    model = $1 if model =~ /(FAP\d{2}|KJEA\d{3}|MFAC\d{2}|RDH-Z80U|E99|Slimax)/i
  when /^布鲁雅尔$/
    model = $1 if model =~ /(Sense|\d{3}[A-Z]?)/i
    case model
    when /403|410B/i
      model = "403或410B"
    when /503|510B/i
      model = "503或510B"
    end
  when /^Coway$/
    model = $1 if model =~ /(APM?-\d{4}[A-Z]{1,2})/i
  when /^IQAir$/
    model = "HealthPro #{$1}" if model =~ /(100|150|250|250\/PLUS|GC MultiGas)/i
  when /^LG$/
    model = $1 if model =~ /((?:HPS|PH|PS)-[A-Z]\d{3}[A-Z]{2}|WBS040CP)/i
  when /^SKG$/
    model = $1 if model =~ /(\d{4})/i
  when /^TCL$/
    model = $1.gsub(/ /, '-') if model =~ /([A-Z]{3}-F\d{2,3}[A-Z]|TCL[- ]360)/i
  when /^cado$/
    model = "AP-#{$1}" if model =~ /(?:AP-)?(C\d{3})/i
  when /^东芝$/
    model = $1 if model =~ /(CAF-[A-Z0-9]{4,5})/i
  when /^三星$/
    model  = model.gsub(/AX-34/, 'AX-034').gsub(/^AC-505$/, 'AC-505CMAGA/SC')
    if model =~ /(A[CGX])-?(\d{3}(?:FCVAND|FCVAUW|EPXAUW|HPAWQ|CSAUA|CPAWQ|CMAGA|VKCBB))(?:\/SC)?/
      model = "#{$1}-#{$2}/SC" 
    elsif model =~ /(SA501T[A-Z]CH|SA600C[A-Z]SSEC)/i
      model = $1.gsub(/SSEC/, '')
    elsif model =~ /(VIRUS DOCTOR).+?(501|600)/i
      model = $2
    end
  when /^亚都$/
    if model =~ /(HJZ|KJ[A-Z])-?(\d{3,4}[A-Z]{0,1})/i
      model = $1 + $2 
    elsif model =~ /(KJ\d{3}AS|BG200|CQG200)/i
      model = $1
    end
    model = model.gsub /亚都/, ''
  when /^伊莱克斯$/
    model = $1 if model =~ /(CN500AZ|[A-Z]{3}\d{3,4}|Z\d{4})/i
  when /^双鸟$/
    model = $1 if model =~ /(AC-[\dA-Z]\d{3}[A-Z]?)/i
  when /^夏普$/
    model = $1 + '-' + $2 if model =~ /(FU|FP|CF|CGJ|DW|FZ|IG|KC|KI)-?([A-Z0-9]{3,6})/i
  when /^大金$/
    model = $1 if model =~ /(MC[0-9A-Z]{6,7})/i
  when /^奥司汀$/
    model = $1 + $2 if model =~ /(HM)-?(\d{3})/i
  when /^奥得奥$/
    model = $1 if model =~ /((?:ADA|KJG)\d{3})/i
  when /^奥郎格$/
    model = $1 if model =~ /(AG\d{3})/i
  when /^席爱尔$/
    model = $1 if model =~ /(AC-\d{4})/i
  when /^德龙$/
    model = $1 + $2 if model =~ /(AC)\s*(\d{2,3})/i
  when /^惠而浦$/
    model = $1 if model =~ /(WA-\d{4}FK)/i
  when /^摩瑞尔$/
    model = $1 if model =~ /(M-[0-9A-Z]{3,5})/i
  when /^松下$/
    model = $1 if model =~ /(F-[0-9A-Z]{6})/i
  when /^格力$/
    model = $1 if model =~ /(KJ[0-9A-Z]{5,6})/i
  when /^汇清$/
    model = $1 if model =~ /(HQ-[0-9A-Z]{4})/i
  when /^海信$/
    model = $1 if model =~ /(KJ[0-9A-Z]+)/i
  when /^海尔$/
    model = $1 if model =~ /(KJ[0-9A-Z]+)/i
  when /^瑞士风$/
    model = $2 if model =~ /(AOS|瑞士风)\s*([0-9A-Z]{4,5})/i
  when /^美的$/
    model = $1 + '-' + $2 if model =~ /(KJ\d{2}[FC][A-Z]?)-([A-Z]{1,2})/i
  when /^艾美特$/
    model = $1 if model =~ /(AC\d{2})/i
  when /^范罗士$/
    model = "AeraMax " + $1 if model =~ /(DX55|DX5|DX96|100|190|200|290|300|90)/i
  when /^西屋$/
    model = $1 if model =~ /(AP-\d{3})/i
  when /^三菱重工$/
    model = $1 if model =~ /(SP[A-Z]-\d{3}AC)/i
  when /^远大$/
    model = $1 if model =~ /(T[ABD]\d+)/i
  when /^霍尼韦尔$/
    model = $1 if model =~ /(\d{5}|5010|(?:[A-Z]{3})-\d{3,5})(?:APCN)?/i
    model = model.gsub(/霍尼韦尔\s*/, '')
    if model =~ /^904/
      @is_good_record = false 
      next
    end
  when /^飞利浦$/
    model = $1 if model =~ /((?:AC|HU|ACP|ACA|CP)\d+)/i
  end

  model = model.upcase.strip
#  warn "#{record['brand']} => #{record['model']} => #{model}"
  record['model'] = model
end
