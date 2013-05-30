module ApplicationHelper

  def local_time(date)
    if date
      pdt   = ActiveSupport::TimeZone.new('Pacific Time (US & Canada)')
      date += (pdt.now.formatted_offset.to_i).hour
    end
    date
  end

  def nsdate_format(date)
    date.strftime("%Y-%m-%d %H:%M:%S %z") if date
  end

  def title
    @title ? @title : 'Bite'
  end

  def to_html(str)
    simple_format h(str)
  end

end
