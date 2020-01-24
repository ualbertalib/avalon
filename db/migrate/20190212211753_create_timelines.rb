class CreateTimelines < ActiveRecord::Migration[5.1]
  def change
    
    # Rails v4.x to Rails v5.2: update default id columns from :integer to :bigint, auto_increment: true
    change_column :annotations, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :annotations, :playlist_item_id, :bigint
    change_column :api_tokens, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :batch_entries, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :batch_entries, :batch_registries_id, :bigint
    change_column :batch_registries, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :batch_registries, :user_id, :bigint
    change_column :bookmarks, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :bookmarks, :user_id, :bigint, null: false
    change_column :courses, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :identities, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :ingest_batches, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :migration_statuses, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :minter_states, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :playlist_items, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :playlist_items, :playlist_id, :bigint, null: false
    change_column :playlist_items, :clip_id, :bigint, null: false
    change_column :playlists, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :playlists, :user_id, :bigint, null: false
    change_column :role_maps, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :role_maps, :parent_id, :bigint
    change_column :searches, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :searches, :user_id, :bigint
    change_column :sessions, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :stream_tokens, :id, :bigint, null: false, unique: true, auto_increment: true
    change_column :users, :id, :bigint, null: false, unique: true, auto_increment: true

    # add timelines table: new feature
    create_table :timelines do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.string :visibility
      t.text :description
      t.string :access_token
      t.string :tags
      t.string :source
      t.text :manifest

      t.timestamps
    end
  end
end
