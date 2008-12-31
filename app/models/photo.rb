require 'rubygems'
require "rexml/document"
require "open-uri"

class Photo < ActiveRecord::Base
  ACCOUNTS=[
    { :user_name => "akio0911",
      :feed_url => 'http://api.flickr.com/services/feeds/photos_public.gne?id=17653213@N05&lang=en-us&format=rss_200'
    },
    { :user_name => "yuiseki",
      :feed_url => 'http://api.flickr.com/services/feeds/photos_public.gne?id=90041784@N00&lang=en-us&format=rss_200'
    },
    { :user_name => "oquno",
      :feed_url => 'http://api.flickr.com/services/feeds/photos_public.gne?id=56264773@N00&lang=en-us&format=rss_200'
    },
    { :user_name => "momo_dev",
      :feed_url => 'http://api.flickr.com/services/feeds/photos_public.gne?id=7665030@N03&lang=en-us&format=rss_200'
    },
  ]
  def self.get_photos
    ACCOUNTS.each do |account|
      xml = open(account[:feed_url]).read
      doc = REXML::Document.new xml
      doc.elements.each('/rss') do |rss|
        rss.elements.each('channel') do |channel|
          channel.elements.each('item') do |item|
            photo = Photo.new
            photo.user_name = account[:user_name]
            item.elements.each('media:content') do |media_content|
              photo.url = media_content.attributes["url"] 
            end
            item.elements.each('media:thumbnail') do |media_thumbnail|
              photo.url_thumbnail = media_thumbnail.attributes["url"] 
            end
            item.elements.each('dc:date.Taken') do |taken|
              photo.taken_at =  taken.text
            end
            unless Photo.find(:first, :conditions => ["url = ?", photo.url])
              photo.save
            end
          end
        end
      end
    end
  end
end
