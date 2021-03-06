class AssignDefaultValueToPlaylistTags < ActiveRecord::Migration[5.1]
  def change
    # Default value of [] for tags is being set by an after_initialize callback
    Playlist.where(tags: nil).each {|p| p.save!(validate: false) }
  end
end
