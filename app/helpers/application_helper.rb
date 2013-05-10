module ApplicationHelper

  def title
    @title ? @title : 'Bite'
  end

  def to_html(str)
    simple_format h(str)
  end

end
