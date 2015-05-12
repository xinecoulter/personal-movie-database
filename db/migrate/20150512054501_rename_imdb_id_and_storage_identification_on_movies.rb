class RenameImdbIdAndStorageIdentificationOnMovies < ActiveRecord::Migration
  def change
    rename_column :movies, :imdb_id, :imdb_identifier
    rename_column :movies, :storage_identification, :storage_identifier
  end
end
