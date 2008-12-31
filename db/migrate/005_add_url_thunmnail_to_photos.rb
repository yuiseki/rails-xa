class AddUrlThunmnailToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :url_thumbnail, :string
  end

  def self.down
    remove_column :photos, :url_thumbnail
  end
end
