# -*- coding: utf-8 -*-
class CreateStatuses < ActiveRecord::Migration
=begin
  def self.up
    create_table :statuses do |t|
      t.column :status_id, :integer # <id>1071821349</id>

      t.column :status_created_at, :datetime # <created_at>Mon Dec 22 06:34:18 +0000 2008</created_at>
      t.column :user_location, :string # <location>Tokyo, Japan</location>
      t.column :status_text, :string # <text>Reblog感覚でプレゼン</text>
      t.column :user_screen_name, :string # <screen_name>yuiseki</screen_name>      

      t.column :float, :latitude # google apiで変換
      t.column :float, :longitude # google apiで変換

      t.timestamps
    end
    add_index :status, [:status_id], :unique=>true
  end
=end

  def self.down
    drop_table :statuses
  end
end
