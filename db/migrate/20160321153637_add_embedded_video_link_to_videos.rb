class AddEmbeddedVideoLinkToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :embedded_link, :string
  end
end
