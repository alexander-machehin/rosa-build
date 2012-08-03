class AddSaveToRepositoryToBuildLists < ActiveRecord::Migration
  def self.up
    add_column :build_lists, :save_to_repository_id, :integer

    BuildList.scoped.find_in_batches do |batch|
      batch.each do |bl|
        begin
          project = bl.project
          platform = bl.save_to_platform

          rep = (project.repositories.map(&:id) & platform.repositories.map(&:id)).first
          bl.save_to_repository_id = rep
          bl.save
        rescue
          false
        end
      end
    end
  end

  def self.down
    remove_column :build_lists, :save_to_repository_id
  end
end