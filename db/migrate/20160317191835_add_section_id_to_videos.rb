class AddSectionIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :section_id, :integer
  end
end
