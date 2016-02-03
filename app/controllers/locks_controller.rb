class LocksController < ApplicationController
  def create
    resource = Resource.find_or_create_by(name: params["resource_name"])
    
    lock = Lock.find_by_resource_id(resource.id)

    if lock.present?
      render status: 409, json: lock
    else
      lock = Lock.create!(resource_id: resource.id, owner: params["owner"])
      render status: 200, json: lock
    end
  end
end
