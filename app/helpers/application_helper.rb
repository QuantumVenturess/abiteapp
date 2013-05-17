module ApplicationHelper

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
