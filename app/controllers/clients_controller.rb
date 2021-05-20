class ClientsController < ApplicationController
  def index
    @q = Client.ransack(params[:q])
    @searched = !params[:q].nil?
    @searched_term = params[:q]&.values&.first
    @clients = @q.result(distinct: true)
  end

<<<<<<< HEAD
  def show
    @client = Client.find(params[:id])
    @existing_voucher = @swap&.vouchers&.find_by(client: @client)
    @red_flagged = Client.where(id: @client).joins(:red_flags)
    @flagged_hotels = @client.hotels.pluck(:name)
=======
  def search
    q = params[:q].downcase
    clients = Client.includes(:incident_reports)
      .where("first_name ILIKE ? or last_name ILIKE ?", "%#{q}%", "%#{q}%").limit(8)
    @results = clients.map do |c| 
      attrs = c.slice(:id, :first_name, :last_name, :name, :date_of_birth)
      attrs.merge(
        banned: c.banned, 
        red_flag: c.incident_reports.any?,
        flagged_hotels: c.flagged_hotels.pluck(:id, :name)
      )
    end
    render json: @results
  end

  def show
    @client = Client.find(params[:id])
    @existing_voucher = @client.current_voucher
    @editing = params[:editing]
  end

  def update
    @client = Client.find(params[:id])
    client_params = params.require(:client).permit!

    if client_params['date_of_birth'].blank?
      client_params['date_of_birth'] = '1600-01-01'
    end

    client_params.merge!(
      race: client_params[:race].reject {|r| r == "0" }.sort,
    )

    if @client.update(client_params)
      return redirect_to @client
    end
    render :show
  end

  def create
    client_params = params.require('client').permit(:first_name, :last_name, :date_of_birth)
    if client_params['date_of_birth'].blank?
      client_params['date_of_birth'] = '1600-01-01'
    end

    client = Client.new(client_params)
    if client.save
      return render json: client, status: :ok
    end

    render json: client.errors.full_messages, status: :unprocessable_entity
>>>>>>> 81f1f12cb6be2f93e4bdb0be295d2865f63f0c8e
  end
end
