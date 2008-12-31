# -*- coding: utf-8 -*-
#require 'feed-normalizer'
require 'uri'
require 'open-uri'

module PlansHelper
  ROWSPAN = 6
  LOCK_IMG_URL = 'http://assets0.twitter.com/images/icon_lock_sidebar.gif'
  def td(plan, i)
    string = ''
    if (plan.start + 10.minute * (i+1)) < Time.now
      string += "<td class=\"past\">"
      string += start_to_string(plan.start, i)
      string += "</td>"

      if i == 0
        string += "<td class=\"plan-past\" rowspan=\"#{ROWSPAN}\">"
        string += plan.content
        string += "</td>"

        #string += "<td rowspan=\"#{ROWSPAN}\"><img src=\"#{LOCK_IMG_URL}\"></td>"
        string += "<td rowspan=\"#{ROWSPAN}\">#{ link_to '編集', edit_plan_path(plan)}</td>"
        string += "<td rowspan=\"#{ROWSPAN}\"></td>"
      end
    elsif Time.now < (plan.start + 10.minute * i)
      string += "<td class=\"future\">"
      string += start_to_string(plan.start, i)
      string += "</td>"

      if i == 0
        string += "<td class=\"plan-future\" rowspan=\"#{ROWSPAN}\">"
        string += plan.content
        string += "</td>"

        unless plan.flag
          string += "<td rowspan=\"#{ROWSPAN}\">#{ link_to '編集', edit_plan_path(plan)}</td>"
          string += "<td rowspan=\"#{ROWSPAN}\">#{ link_to '表示', plan_path(plan)}</td>"
        else
          #string += "<td rowspan=\"#{ROWSPAN}\"><img src=\"#{LOCK_IMG_URL}\"></td>"
          string += "<td rowspan=\"#{ROWSPAN}\">#{ link_to '編集', edit_plan_path(plan)}</td>"
          string += "<td rowspan=\"#{ROWSPAN}\"></td>"
        end
      end
    else
      string += "<td class=\"now\">"
      string += start_to_string(plan.start, i)
      string += ' now!'
      string += "</td>"

      if i == 0
        string += "<td class=\"plan-now\" rowspan=\"#{ROWSPAN}\">"
        string += plan.content
        string += "</td>"

        string += "<td rowspan=\"#{ROWSPAN}\"><img src=\"#{LOCK_IMG_URL}\"></td>"
        string += "<td rowspan=\"#{ROWSPAN}\"></td>"
      end
    end
    return string
  end
  private
  def start_to_string(start, i)
    string = ''
    string += (start + 10.minute * i).strftime("%d日 %H:%M～")
    string += (start + 10.minute * (i+1)).strftime("%H:%M")
    return string
  end
end
