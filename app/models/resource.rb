class Resource < ActiveRecord::Base
  validates_presence_of :name

  has_many :locks
end
