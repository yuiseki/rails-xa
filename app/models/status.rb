require 'rubygems'
require "rexml/document"
require "open-uri"

class Status < ActiveRecord::Base
  ACCOUNTS=[
    {:twitter => "ssig33", :ustream => 28719},
    {:twitter => "yuiseki", :ustream => 69676},
    {:twitter => "oquno", :ustream => 126804},
    {:twitter => "akio0911", :ustream => 72009},
    {:twitter => "takano32", :ustream => 20100},
    {:twitter => "pha", :ustream => 25763},
    {:twitter => "riko", :ustream => 254761},
    {:twitter => "voqn", :ustream => 62213},
  ]

  def self.get_xml
    ACCOUNTS.each do |accounts|
      get_xml_page(accounts[:twitter], 1)
    end
  end
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
          s.user_location = status.elements['user/location'].text
          s.status_text = status.elements['text'].text
          s.user_screen_name = status.elements['user/screen_name'].text
          s.save
        end
      end
    end
  end
end
