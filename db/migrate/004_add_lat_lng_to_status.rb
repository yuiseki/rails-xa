# -*- coding: utf-8 -*-
class AddLatLngToStatus < ActiveRecord::Migration
  def self.up
#    remove_column :statuses, :float # rake db:migrate で実行するとエラー出るから放置

    add_column :statuses, :latitude, :float
    add_column :statuses, :longitude, :float
    add_column :statuses, :update_location, :boolean
  end

  def self.down
    remove_column :statuses, :latitude
    remove_column :statuses, :longitude
    remove_column :statuses, :update_location

#    add_column :statuses, :float, :float # rake db:migrate で実行するとエラー出るから放置
  end
end
