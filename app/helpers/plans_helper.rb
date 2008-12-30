module PlansHelper
  def td(plan)
    string=""
    unless plan.flag?
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
      else
        string += "<td style=\"font-size:1.6em;padding:10px;border-bottom:1px solid black;color:#ccc;\">"
        string += plan.start.strftime("%d日 %H:%M～")
        string += " now!" if Time.now.strftime("%d%H") == plan.start.strftime("%d%H")
        string += "</td>"
        string += "<td style=\"width:420px;font-size:1.6em;padding:10px;border-bottom:1px solid black;\">"
        string += plan.content
        string += "</td>"
        string += "<td><img src=\"http://assets0.twitter.com/images/icon_lock_sidebar.gif\"></td>"
      end
    else
      string += "<td style=\"font-size:1.6em;padding:10px;border-bottom:1px solid black;color:red;\">"
      string += plan.start.strftime("%d日 %H:%M～")
      string += "</td>"
      string += "<td style=\"width:420px;font-size:1.6em;padding:10px;border-bottom:1px solid black;\">"
      string += plan.content
      string += "</td>"
      string += "<td><img src=\"http://assets0.twitter.com/images/icon_lock_sidebar.gif\"></td>"
    end
  end
end
