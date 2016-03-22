class AddVideoIdsToSections < ActiveRecord::Migration
  def change
    add_column :sections, :video_ids, :integer
  end
end
