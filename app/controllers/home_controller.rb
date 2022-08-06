class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:top]
  def top
  end
end
