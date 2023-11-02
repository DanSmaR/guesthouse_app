class HomeController < ApplicationController
  def index
    @guesthouses = Guesthouse.all.filter(&:active)
  end
end
