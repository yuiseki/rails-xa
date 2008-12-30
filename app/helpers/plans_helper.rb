# -*- coding: utf-8 -*-
#require 'feed-normalizer'
require 'uri'
require 'open-uri'

module PlansHelper
  def td(plan, i)
    string=""

    if Time.now < (plan.start + 10.minute * i)
      string += '<td class="past">'
        string += start_to_string(plan.start, i)
    elsif (plan.start + 10.minute * (i+1)) < Time.now
      string += '<td class="future">'
        string += start_to_string(plan.start, i)
    else
      string += '<td class="now">'
        string += start_to_string(plan.start, i)
      string += 'now!'
    end
    string += "</td>"

    if not plan.flag? and i == 0
      editable_time = Time.now+60*60
      if plan.start > editable_time
        string += "<td style=\"width:420px;font-size:1.6em;padding:10px;border-bottom:1px solid black;\">"
        string += plan.content
        string += "</td>"
        string += "<td>#{ link_to '編集', edit_plan_path(plan)}</td>"
        string += "<td>#{ link_to '表示', plan_path(plan)}</td>"
      else
        string += "<td style=\"width:420px;font-size:1.6em;padding:10px;border-bottom:1px solid black;\">"
        string += plan.content
        string += "</td>"
        string += "<td><img src=\"http://assets0.twitter.com/images/icon_lock_sidebar.gif\"></td>"
        string += "<td></td>"
      end
    else
      string += "<td style=\"width:420px;font-size:1.6em;padding:10px;border-bottom:1px solid black;\">"
      string += plan.content
      string += "</td>"
      string += "<td><img src=\"http://assets0.twitter.com/images/icon_lock_sidebar.gif\"></td>"
      string += "<td></td>"
    end
  end
  private
  def start_to_string(start, i)
    string = ''
    string += (start + 10.minute * i).strftime("%d日 %H:%M～")
    string += (start + 10.minute * (i+1)).strftime("%H:%M")
    return string
  end
end
