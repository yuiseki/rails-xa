# -*- coding: utf-8 -*-
require 'rubygems'
require "rexml/document"
require "open-uri"
#require 'lib/geocoder'

class Status < ActiveRecord::Base
  ACCOUNTS=[
    {:twitter => "github"  , :ustream => nil},
    # {:twitter => "ssig33"   , :ustream => 28719},
    {:twitter => "yuiseki"  , :ustream => 69676},
    {:twitter => "oquno"    , :ustream => 126804},
    {:twitter => "akio0911" , :ustream => 72009},
    {:twitter => "takano32" , :ustream => 20100},
    {:twitter => "itkz"     , :ustream => 18990},
    # {:twitter => "voqn"     , :ustream => 62213},
    # {:twitter => "showyou"  , :ustream => 84075},
    # {:twitter => "momo_dev" , :ustream => 18990},
    # {:twitter => "kira88"   , :ustream => nil},
    {:twitter => "pha"      , :ustream => 25763},
    {:twitter => "riko"     , :ustream => 254761},
    {:twitter => "bulkneets", :ustream => nil},
    {:twitter => "mi8_r"    , :ustream => nil},
    # {:twitter => "uta"      , :ustream => nil},
    {:twitter => "mizunon"  , :ustream => nil},
    {:twitter => "popona"   , :ustream => nil},
    {:twitter => "retlet"   , :ustream => nil},
  ]

  def self.hour(time)
    statuses = Status.find(:all,
                :order => "status_created_at DESC",
                :conditions => ["status_created_at BETWEEN ? and ?",
                                time-30.minutes, time ]
                )
  end

  def self.get_xml
    ACCOUNTS.each do |accounts|
      get_xml_page(accounts[:twitter], 1)
    end
  end

  def self.update_location
    Status.find(:all, :conditions => ['update_location IS NULL OR update_location = ?', false]).each do |status|
      if status.status_text =~ /L:(.*?)($| |\[)/
        address = $1
        key = 'ABQIAAAAItgJY90WDE2sJTtuP-HIIhRrtpwTjkhgWCZnergad-XLaWIj6RQeUpAp0EEYkwMmTlOLHT52UfoEjA'
        format = "xml"
        g = Geocoder.new(key, format)
        point = g.getPoint($1)
        if point
          latitude = point[1]
          longitude = point[0]
          status.latitude = latitude
          status.longitude = longitude
          status.update_location = true
          status.save
        end
      end
    end
  end

  def self.get_xml_github
    xml = open("http://github.com/feeds/yuiseki/commits/rails-xa/master").read
    doc = REXML::Document.new xml
    doc.elements.each('/feed') do |feed|
      feed.elements.each('entry') do |entry|
        status_text = entry.elements['author/name'].text + ':' + entry.elements['title'].text
        status_created_at = DateTime.parse(entry.elements['updated'].text)
        status_created_at += 9.hour + 8.hour
        user_screen_name = 'github'
        unless Status.find(:first, :conditions => ["status_created_at = ? AND user_screen_name = ?", status_created_at, user_screen_name])
          s = Status.new
          s.status_text = status_text
          s.status_created_at = status_created_at
          s.user_screen_name = user_screen_name
          s.save
        end
      end
    end
  end

  private
  def self.get_xml_page(user, page)
    xml = open("http://twitter.com/statuses/user_timeline/#{user}.xml?page=#{page}").read
    doc = REXML::Document.new xml
    doc.elements.each('/statuses') do |statuses|
      statuses.elements.each('status') do |status|
        status_id = status.elements['id'].text
        unless Status.find(:first, :conditions => ["status_id = ?", status_id])
          s = Status.new
          s.status_id = status.elements['id'].text
          s.status_created_at = status.elements['created_at'].text
          s.status_created_at += 9.hour
          s.user_location = status.elements['user/location'].text
          s.status_text = status.elements['text'].text
          s.user_screen_name = status.elements['user/screen_name'].text
          s.save
        end
      end
    end
  end
end
