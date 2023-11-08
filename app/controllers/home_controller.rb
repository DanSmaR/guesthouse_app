class HomeController < ApplicationController
  def index
    # last 3 active guesthouses ordered by created_at desc
    @guesthouses = Guesthouse.all
    @active_guesthouses = @guesthouses.filter(&:active)
    @guesthouses_last_three = @active_guesthouses.last(3)
                                        .sort_by(&:created_at).reverse
    @guesthouses_remaining = {}
    unless @guesthouses_last_three.count < 3
      @guesthouses_remaining = @active_guesthouses
                                         .first(@active_guesthouses.count - 3)
                                         .sort_by(&:created_at).reverse
    end
    @cities = @active_guesthouses.map(&:address).map(&:city).uniq
  end
end
