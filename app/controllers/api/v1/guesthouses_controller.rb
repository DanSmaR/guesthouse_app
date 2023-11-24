class Api::V1::GuesthousesController < Api::V1::ApiController
  def index
    guesthouses = Guesthouse.where(active: true)
    if params[:search]
      guesthouses = guesthouses.where('brand_name LIKE ?', "%#{params[:search]}%")

    end
    render json: guesthouses.as_json(except: [:created_at, :updated_at, :registration_code, :corporate_name],
                                     include: [:address, :payment_methods], status: :ok)
  end
end