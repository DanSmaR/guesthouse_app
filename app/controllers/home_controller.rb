class HomeController < ApplicationController
  def index
    @guesthouses = Guesthouse.first(3)
  end
end
