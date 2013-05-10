module PlacesHelper

  def phone_number(number)
    n = number.to_s.split('')
    if n.size >= 10
      "(#{n[0..2].join('')}) #{n[3..5].join('')}-#{n[6..9].join('')}"
    else
      number
    end
  end
end
