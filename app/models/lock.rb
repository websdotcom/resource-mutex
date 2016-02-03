class Lock < ActiveRecord::Base
  validates_presence_of :resource_id, :owner

  belongs_to :resource
end
