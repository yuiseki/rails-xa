class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :url, :string
      t.column :user_name, :string
      t.column :taken_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
