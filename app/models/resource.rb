class Resource < ActiveRecord::Base
  validates_presence_of :name

  has_one :lock
end
