class ProjectStatistic < ActiveRecord::Base

  belongs_to :arch
  belongs_to :project

  validates :arch_id, :project_id, :average_build_time, :build_count, presence: true
  validates :project_id, uniqueness: { scope: :arch_id }

  attr_accessible :average_build_time, :build_count
end
