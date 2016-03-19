class AddWatchedColumnToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :watched, :string
  end
end
