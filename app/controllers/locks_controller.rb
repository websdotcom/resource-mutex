class LocksController < ApplicationController
  def create
    resource = Resource.find_or_create_by(name: params["resource_name"])

    render invalid_object_error(resource) and return unless resource.valid?

    lock = Lock.find_by_resource_id(resource.id)

    if lock.present?
      reject_lock_request(lock)
    else
      grant_lock_request(resource)
    end
  end

  private

  def grant_lock_request(resource)
    lock = Lock.create(resource_id: resource.id, owner: params["owner"])

    if lock.valid?
      render status: 200, json: lock
    else
      render invalid_object_error(lock)
    end
  end

  def reject_lock_request(lock)
    render status: 409, json: lock
  end

  def invalid_object_error(object)
    { status: 500, 
        json: { errors: object.errors.full_messages.join(",") }
    } 
  end
end
