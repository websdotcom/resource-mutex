class ResourcesController < ApplicationController
  def create
    resource = Resource.new(name: params["name"] )

    if resource.save
      render status: 201, json: resource
    else
      render status: 500, json: { errors: resource.errors.full_messages.join(",") }
    end
  end
end
