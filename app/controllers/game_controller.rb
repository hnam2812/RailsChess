class GameController < ApplicationController
  before_action :authenticate_user!

  def new
    Seek.create current_user.id.to_s
  end
end
