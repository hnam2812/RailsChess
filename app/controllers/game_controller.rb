class GameController < ApplicationController
  before_action :authenticate_user!
end
