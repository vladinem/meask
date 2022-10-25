class UsersController < ApplicationController

  def index
  end
  def show
    @time = Time.now
    @hello = "Current time:"
  end
end
