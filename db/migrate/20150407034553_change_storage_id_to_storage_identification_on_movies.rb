class ChangeStorageIdToStorageIdentificationOnMovies < ActiveRecord::Migration
  def change
    rename_column :movies, :storage_id, :storage_identification
  end
end
