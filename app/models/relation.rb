class Relation < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :object, :polymorphic => true

  ROLES = %w[reader writer admin]
  validates :role, :inclusion => {:in => ROLES}

  scope :by_object, lambda {|obj| {:conditions => ['object_id = ? AND object_type = ?', obj.id, obj.class.to_s]}}
  scope :by_target, lambda {|tar| {:conditions => ['target_id = ? AND target_type = ?', tar.id, tar.class.to_s]}}
end
