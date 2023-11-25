class Api::V1::GuesthousesController < Api::V1::ApiController
  def index
    guesthouses = Guesthouse.all.where(active: true)
    if params[:search]
      guesthouses = guesthouses.where('brand_name LIKE ?', "%#{params[:search]}%")

    end
    guesthouses = guesthouses.map(&method(:format_attributes))
    render json: guesthouses.as_json(except: [:created_at, :updated_at, :registration_code, :corporate_name],
                                     include: [:address, :payment_methods]), status: :ok
  end

  def show
      guesthouse = Guesthouse.find(params[:id])
      render json: format_attributes(guesthouse)
  end

  private

  def format_attributes(guesthouse)
    guesthouse.as_json(except: [:created_at, :updated_at, :registration_code, :corporate_name],
                       include: { address: { except: [:created_at, :updated_at] },
                                  payment_methods: { except: [:created_at, :updated_at] } })
              .merge(checkin_hour: guesthouse.checkin_hour.strftime("%H:%M"),
                     checkout_hour: guesthouse.checkout_hour.strftime("%H:%M"),
                     average_rating: guesthouse.average_rating)
  end
end