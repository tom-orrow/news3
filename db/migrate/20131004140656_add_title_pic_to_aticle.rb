class AddTitlePicToAticle < ActiveRecord::Migration
  def self.up
    add_attachment :articles, :title_pic
  end

  def self.down
    remove_attachment :articles, :title_pic
  end
end
