class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.string :link
      t.string :year
      t.string :watched
      t.string :embedded_link
    end
  end
end
