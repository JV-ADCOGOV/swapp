class ClientsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :set_client, only: %i[show update]

  def index
    @q = Client.ransack(params[:q])
    @searched = !params[:q].nil?
    @searched_term = params[:q]&.values&.first
    @clients = @q.result(distinct: true)
  end

  def search
    results = ClientSearch.search(params[:q])
    render json: results
  end

  def show; end

  def update
    client_params = params.require(:client).permit!

    if client_params['date_of_birth'].blank?
      client_params['date_of_birth'] = '1600-01-01'
    end

    # client_params[:race] = client_params[:race].reject { |r| r == '0' }.sort
    data_url = client_params.delete(:camera)

    if @client.update(client_params)
      if data_url.present?
        # The data is Base64 and coming from the camera.
        # Use that data to create a file for active storage.
        # data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD....
        blob =
          ActiveStorage::Blob.create_after_upload!(
            io: StringIO.new((Base64.decode64(data_url.split(',')[1]))),
            filename: 'profile_photo.jpeg',
            content_type: 'image/jpeg',
          )

        @client.profile_photo.attach(blob)
      end

      return redirect_to @client
    end

    render :show
  end

  # POST /clients
  # guests form sends xhr request to this endpoint
  # new clients are normally created in conjunction with intakes in intakes#create
  def create
    client_params =
      params
        .require('client')
        .permit(
          :first_name,
          :last_name,
          :date_of_birth,
          :hmis_id,
          :profile_photo,
          :camera,
        )
    if client_params['date_of_birth'].blank?
      client_params['date_of_birth'] = '1600-01-01'
    end

    client = Client.new(client_params.merge(force_intake: true))
    return render json: client, status: :ok if client.save

    render json: client.errors.full_messages, status: :unprocessable_entity
  end

  def set_client
    @client = Client.find(params[:id])
    @existing_voucher = @client.current_voucher
    @editing = params[:editing]
    @hotels = Hotel.all
    @hotel_map = Hotel.all.pluck(:id, :name).to_h
    @incidents =
      @client
        .incident_reports
        .order(created_at: :desc)
        .map do |incident|
          {
            reportedBy: {
              firstName: incident.reporter.first_name,
              lastName: incident.reporter.last_name,
              email: incident.reporter.email,
            },
            dateOfIncident: incident.occurred_at,
            description: incident.description,
          }
        end
    @incident_report = IncidentReport.new
  end
end
