# -*- coding: utf-8 -*-
#require 'feed-normalizer'
require 'uri'
require 'open-uri'

module PlansHelper
  def gmaps_markers(start_time, end_time)
    html=""
    Status::ACCOUNTS.each do |account|
       tw = Status.geo(account[:twitter], start_time, end_time)
       if tw
         #tw = tw[0]
         tw.each do |po|
           html += <<-EOS
            var latlng = new GLatLng(#{po.latitude}, #{po.longitude});
            var icon = new GIcon(G_DEFAULT_ICON);
            icon.image =" http://usericons.relucks.org/twitter/#{po.user_screen_name}";
            var icon_size = 48/2;
            icon.iconSize = new GSize(icon_size, icon_size);
            icon.iconAhchor = new GPoint(icon_size, icon_size);
            icon.imageMap = [0,0, icon_size,0, icon_size,icon_size, 0,icon_size];
            var mk = new GMarker(latlng, icon);
            map.addOverlay(mk);
           EOS
         end
       end
    end
    return html
  end

  def ustreamer
    html=""
    Status::ACCOUNTS.each do |account|
      if accounts[:ustream] then
        html += <<-EOS
          <embed flashvars='viewcount=true&amp;autoplay=false&amp;brand=embed' width='160' height='130' allowfullscreen='true' allowscriptaccess='always'
          src='http://www.ustream.tv/flash/live/1/<%= account[:ustream] %>' type='application/x-shockwave-flash' />
        EOS
      end
    end
  end

  def location_list_html(start_time, end_time)
    html = ""
    Status::ACCOUNTS.each do |account|
      geos = Status.geo(account[:twitter], start_time, end_time)
      if geos
        #tw = geos[0]
        geos.each do |tw|
          html += <<-EOS
            <div class="geo">
            <img alt="#{tw.user_screen_name}" src="http://usericons.relucks.org/twitter/#{tw.user_screen_name}"  height="15" width="15" />
            #{tw.user_screen_name} |
            #{tw.status_created_at.strftime("%y/%m/%d %H:%M")} |
            [緯度:#{tw.latitude} 経度#{tw.longitude}] |
            #{tw.status_text}
            </div>
          EOS
        end
      end
    end
    return html
  end

  def twitter_recent(time)
    html = ""
    Status.recent(time).each do |tw|
      html += <<-EOS
        <span class="tweets">
        <img alt="#{tw.user_screen_name}" src="http://usericons.relucks.org/twitter/#{tw.user_screen_name}"  height="15" width="15"  />
        #{tw.user_screen_name}:
        #{tw.status_text} |
        </span>
      EOS
    end
    return html
  end

  def th
    html = ""
    Status::ACCOUNTS.each do |account|
      unless account[:twitter] == 'github'
        html += <<-EOS
          <th>
            <a href="http://twitter.com/#{account[:twitter]}">
<img src="http://usericons.relucks.org/twitter/#{account[:twitter]}" height="30" width="30" />
              #{account[:twitter]}
            </a>
          </th>
        EOS
      else
        html += <<-EOS
          <th>
            <a href="http://github.com/yuiseki/rails-xa/commits/master/">
            <img src="https://github.com/images/modules/header/logo.png" height="60" width="100"  />
              #{account[:twitter]}
            </a>
          </th>
        EOS
      end
    end
    return html
  end

  def td_log(start)
    html=""
    Status::ACCOUNTS.each_with_index do |account, index|
      html += <<-EOS
        <td class="twitter user#{index%9} %>" valign="top">
      EOS
      Status.slice(account[:twitter], start).each do |status|
        unless account[:twitter] == "github"
          html += <<-EOS
            <span class="tweets">
              [#{status.status_created_at.strftime("%H:%M")}]<br />
              #{link_to status.status_text, "http://twitter.com/" + account[:twitter] + "/status/" + status.status_id.to_s}
            </span><br />
          EOS
        else
          html += <<-EOS
            <span class="tweets" style="color:red;font-size:1.3em;">
              #{status.status_text}
            </span><br />
          EOS
        end
      end
      Photo::ACCOUNTS.each do |flickr|
        if account[:twitter] == flickr[:user_name]
          Photo.slice(account[:twitter], start).each do |photo|
            html += <<-EOS
              <a href="#{photo.url}" class="highslide" onclick="return hs.expand(this)"><img class="flickr" style="max-width:80px;max-height:100px;" src="#{photo.url_thumbnail || photo.url}" /></a>
            EOS
          end
        end
      end
    end
    return html
  end


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
