class BookingsController < ApplicationController
  before_action :authenticate_user!,
                only:
                  [:index, :create, :show, :cancel, :cancel_by_guesthouse_owner, :guesthouse_owner]

  def index
    @bookings = get_guest_bookings if current_user&.guest?
  end

  def guesthouse_owner
    @bookings = get_guesthouse_owner_bookings if current_user&.guesthouse_owner?
    render :index
  end

  def active
    @bookings = get_guesthouse_owner_active_bookings if current_user&.guesthouse_owner?
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

    if @booking&.required_fields && @booking.check_availability
      session[:booking] = booking_params.to_h
      session[:booking][:room_id] = @room.id
      flash[:notice] = 'Quarto disponível!'
      redirect_to confirm_room_bookings_path(@room)
    else
      flash.now[:alert] = 'Quarto não disponível neste período. Tente novamente'
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
    @booking&.prepare_for_creation(@guesthouse, current_user.guest)
    if @booking&.save
      session[:booking] = nil
      flash[:notice] = 'Reserva realizada com sucesso!'
      redirect_to booking_path(@booking)
    else
      flash.now[:alert] = 'Não foi possível realizar a reserva. Tente novamente'
      render :new
    end
  end

  def show
    if current_user&.guest? && current_user.guest.bookings.exists?(params[:id])
      @booking = current_user.guest.bookings.find(params[:id])
    elsif current_user&.guesthouse_owner?
      @booking = nil
      current_user.guesthouse_owner.guesthouse.rooms.each do |room|
        @booking = room.bookings.find(params[:id]) if room.bookings.exists?(params[:id])
      end
    end
  end

  # TODO: Create a table to store who canceled the booking
  def cancel
    @booking = current_user.guest.bookings.find(params[:id])
    if @booking&.check_in_date >= Date.today + 7
      @booking&.canceled!
      @bookings = get_guest_bookings
      flash[:notice] = 'Reserva cancelada com sucesso!'
      redirect_to bookings_path
    else
      @bookings = get_guest_bookings
      flash[:alert] = 'Não é possível cancelar a reserva com menos de 7 dias de antecedência.'
      redirect_to bookings_path
    end
  end

  def cancel_by_guesthouse_owner
    @booking = nil
    current_user.guesthouse_owner.guesthouse.rooms.each do |room|
      @booking = room.bookings.find(params[:id]) if room.bookings.exists?(params[:id])
    end
    if validate_cancel_conditions
      @booking&.canceled!
      @bookings = get_guesthouse_owner_bookings
      flash[:notice] = 'Reserva cancelada com sucesso!'
      redirect_to guesthouse_owner_bookings_path
    else
      @bookings = get_guesthouse_owner_bookings
      flash[:alert] = 'Não é possível cancelar a reserva com menos de 2 dias de atraso.'
      redirect_to guesthouse_owner_bookings_path
    end
  end

  def check_in
    @booking = nil
    current_user.guesthouse_owner.guesthouse.rooms.each do |room|
      @booking = room.bookings.find(params[:id]) if room.bookings.exists?(params[:id])
    end
    if @booking&.can_check_in
      @booking&.active!
      @booking&.update(check_in_confirmed_date: Date.today, check_in_confirmed_hour: Time.now)
      flash[:notice] = 'Check-in realizado com sucesso!'
      redirect_to booking_path(@booking)
    else
      flash[:alert] ="Reserva #{@booking&.reservation_code} #{@booking&.errors&.full_messages&.join('. ')}"
      redirect_to guesthouse_owner_bookings_path
    end
  end

  private

  def validate_cancel_conditions
    !@booking.nil? && @booking&.pending? && @booking&.check_in_date + 2.days <= Date.today
  end

  def get_guest_bookings
    current_user.guest.bookings.where(status: :pending)
  end

  def get_guesthouse_owner_bookings
    bookings = []
    current_user.guesthouse_owner.guesthouse.rooms.each do |room|
      room.bookings.where(status: :pending).each do |booking|
        bookings << booking
      end
    end
    bookings
  end

  def get_guesthouse_owner_active_bookings
    bookings = []
    current_user.guesthouse_owner.guesthouse.rooms.each do |room|
      room.bookings.where(status: :active).each do |booking|
        bookings << booking
      end
    end
    bookings
  end

  def booking_params
    params.require(:booking).permit(:check_in_date, :check_out_date, :number_of_guests)
  end
end
