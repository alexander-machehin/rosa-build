class Subscribe < ActiveRecord::Base
  belongs_to :subscribeable, :polymorphic => true
  belongs_to :user
end