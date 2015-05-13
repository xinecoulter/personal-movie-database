class ChangeStorageIdentifierDataTypeOnMovies < ActiveRecord::Migration
  def up
    change_column :movies, :storage_identifier, :string
  end
  def down
    change_column :movies, :storage_identifier, :integer
  end
end
