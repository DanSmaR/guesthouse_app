class HomeController < ApplicationController
  def index
    @guesthouses = Guesthouse.all
  end
end
