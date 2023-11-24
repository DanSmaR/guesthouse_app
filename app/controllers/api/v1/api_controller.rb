class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  private

  def not_found_error
    render json: { message: 'Not found' }, status: :not_found
  end
end