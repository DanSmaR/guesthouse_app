class Api::V1::GuesthousesController < Api::V1::ApiController
  def index
    @guesthouse = Guesthouse.where(active: true)
    render json: @guesthouse.as_json(except: [:created_at, :updated_at, :registration_code, :corporate_name],
                                     include: [:address, :payment_methods], status: :ok)
  end
end