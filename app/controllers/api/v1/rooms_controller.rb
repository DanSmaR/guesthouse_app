class Api::V1::RoomsController < Api::V1::ApiController
  def index
    guesthouse = Guesthouse.find(params[:guesthouse_id])
    rooms = guesthouse.rooms.where(available: true)

    render json: rooms.as_json(except: [:created_at, :updated_at, :available]), status: :ok
  end
end