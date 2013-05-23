module CalendarHelper

  def calendar(date = Time.zone.now.to_date, &block)
    Calendar.new(self, date, block).table
  end

  def next_month(date)
    year  = date.year
    month = date.month
    day   = date.day
    if month == 12
      year += 1
      month = 1
    else
      month += 1
    end
    "#{year}-#{month}-#{day}"
  end

  def prev_month(date)
    year  = date.year
    month = date.month
    day   = date.day
    if month == 1
      year -= 1
      month = 12
    else
      month -= 1
    end
    "#{year}-#{month}-#{day}"
  end

  class Calendar < Struct.new(:view, :date, :callback)
    HEADER = %w[Sun Mon Tue Wed Thu Fri Sat]
    START_DAY = :sunday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        header + week_rows
      end
    end

    def header
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << "today" if day == Time.zone.now.to_date
      classes << "notmonth" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end

end
