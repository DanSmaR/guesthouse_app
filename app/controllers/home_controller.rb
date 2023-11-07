class HomeController < ApplicationController
  def index
    # last 3 active guesthouses ordered by created_at desc
    @guesthouses_last_three = Guesthouse.all.filter(&:active).last(3)
                                        .sort_by(&:created_at).reverse
    @guesthouses_remaining = {}
    unless @guesthouses_last_three.count < 3
      @guesthouses_remaining = Guesthouse.all.filter(&:active)
                                         .first(Guesthouse.all.filter(&:active).count - 3)
                                         .sort_by(&:created_at).reverse
    end
  end
end
