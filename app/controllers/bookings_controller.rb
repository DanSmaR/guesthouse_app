class BookingsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create]

  def guesthouse_owner_bookings
    @bookings = get_guesthouse_owner_bookings if current_user&.guesthouse_owner?
    render :index
  end

  def index
    @bookings = get_guest_bookings if current_user&.guest?
  end
  def new
    @room = Room.find(params[:room_id])
    @booking = @room.bookings.new(session[:booking])
    @guesthouse = @room.guesthouse
  end

  def availability
    @room = Room.find(params[:room_id])
    @guesthouse = @room.guesthouse
    @booking = @room.bookings.new(booking_params)

    if @booking.required_fields && @booking.check_availability
      session[:booking] = booking_params.to_h
      session[:booking][:room_id] = @room.id
      flash[:notice] = 'Quarto disponível!'
      redirect_to confirm_room_bookings_path(@room)
    else
      render :new
    end
  end

  def confirm
    @room = Room.find(params[:room_id])
    @booking = @room.bookings.new(session[:booking])
  end

  def final_confirmation
    if current_user&.guest
      @room = Room.find(params[:room_id])
      @guesthouse = @room.guesthouse
      @booking = @room.bookings.new(session[:booking])
    else
      flash[:alert] = 'Faça login ou registre-se para continuar'
      redirect_to new_user_session_path
    end
  end

  def create
    @room = Room.find(params[:room_id])
    @guesthouse = @room.guesthouse
    @booking = @room.bookings.new(session[:booking])
    @booking.prepare_for_creation(@guesthouse, current_user.guest)
    if @booking.save
      session[:booking] = nil
      flash[:notice] = 'Reserva realizada com sucesso!'
      redirect_to booking_path(@booking)
    else
      flash[:alert] = 'Não foi possível realizar a reserva. Tente novamente'
      render :new
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @room = @booking.room
    @guesthouse = @room.guesthouse
  end

  # TODO: Create a table to store who canceled the booking
  def cancel
    @booking = Booking.find(params[:id])
    if @booking.check_in_date >= Date.today + 7
      @booking.canceled!
      @bookings = get_guest_bookings
      flash.now[:notice] = 'Reserva cancelada com sucesso!'
      render :index
    else
      @bookings = get_guest_bookings
      flash.now[:alert] = 'Não é possível cancelar a reserva com menos de 7 dias de antecedência.'
      render :index
    end
  end

  private

  def get_guest_bookings
    current_user.guest.bookings.where.not(status: %w[canceled finished])
  end

  def get_guesthouse_owner_bookings
    bookings = []
    current_user.guesthouse_owner.guesthouse.rooms.each do |room|
      room.bookings.where.not(status: %w[canceled finished]).each do |booking|
        bookings << booking
      end
    end
    bookings
  end

  def booking_params
    params.require(:booking).permit(:check_in_date, :check_out_date, :number_of_guests)
  end
end
