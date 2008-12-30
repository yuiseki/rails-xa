# -*- coding: utf-8 -*-
#require 'feed-normalizer'
require 'uri'
require 'open-uri'

module PlansHelper
  def ustream
  end
  def twitter
    uri = "http://twitter.com/statuses/user_timeline/#{user}.atom"
    feed = FeedNormalizer::FeedNormalizer.parse open(uri)
  end
  def td(plan, i)
    string=""
    if not plan.flag? and i == 0
      editable_time = Time.now+60*60
      if plan.start > editable_time
        string += "<td style=\"font-size:1.6em;padding:10px;border-bottom:1px solid black;\">"
        string += plan.start.strftime("%d日 %H:%M～")
        string += " now!" if Time.now.strftime("%d%H") == plan.start.strftime("%d%H")
        string += "</td>"
        string += "<td style=\"width:420px;font-size:1.6em;padding:10px;border-bottom:1px solid black;\">"
        string += plan.content
        string += "</td>"
        string += "<td>#{ link_to '編集', edit_plan_path(plan)}</td>"
        string += "<td>#{ link_to '表示', plan_path(plan)}</td>"
      else
        string += "<td style=\"font-size:1.6em;padding:10px;border-bottom:1px solid black;color:#ccc;\">"
        string += plan.start.strftime("%d日 %H:%M～")
        string += "<span style=\"color:red;\">now!</span>" if Time.now.strftime("%d%H") == plan.start.strftime("%d%H")
        string += "</td>"
        string += "<td style=\"width:420px;font-size:1.6em;padding:10px;border-bottom:1px solid black;\">"
        string += plan.content
        string += "</td>"
        string += "<td><img src=\"http://assets0.twitter.com/images/icon_lock_sidebar.gif\"></td>"
        string += "<td></td>"
      end
    else
      string += "<td style=\"font-size:1.6em;padding:10px;border-bottom:1px solid black;color:red;\">"
      string += plan.start.strftime("%d日 %H:%M～")
      string += "</td>"
      string += "<td style=\"width:420px;font-size:1.6em;padding:10px;border-bottom:1px solid black;\">"
      string += plan.content
      string += "</td>"
      string += "<td><img src=\"http://assets0.twitter.com/images/icon_lock_sidebar.gif\"></td>"
      string += "<td></td>"
    end
  end
end
