class AddSectionIdsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :section_ids, :integer
  end
end
