class IntakesController < ApplicationController
  before_action :hydrate_form, only: %i[ new create ]

  def new
    @intake = Intake.new
    @client = Client.new
    @voucher = Voucher.new
  end

  def create
    @intake = Intake.new(intake_params.except(:voucher).merge(
      have_you_ever_experienced_homelessness_before:
        !ActiveRecord::Type::Boolean.new.cast(intake_params[:homelessness_first_time]),
      non_cash_benefits: intake_params[:non_cash_benefits].reject {|r| r == "0" }
    ))

    client_params = intake_params[:client_attributes]
    @client = Client.new(client_params.merge(
      race: client_params[:race].reject {|r| r == "0" },
      veteran_separation_year: client_params[:veteran_separation_year].presence
    ))

    @intake.client = @client
    @intake.user = current_user

    if !@intake.save
      return render :new
    end

    redirect_to new_voucher_path(client_id: @client.id, intake_id: @intake.id)
  end

  private

  def intake_params
    params.require(:intake).permit(
      :homelessness_first_time,
      :homelessness_date_began,
      :homelessness_episodes_last_three_years,
      :where_did_you_sleep_last_night, 
      {why_not_shelter: []},
      :armed_forces,
      :active_duty, 
      :substance_misuse, 
      :chronic_health_condition,
      :mental_health_disability,
      :physical_disability, 
      :developmental_disability,
      :fleeing_domestic_violence, 
      :homelessness_how_long_this_time,
      :total_how_long_shelters_or_streets,
      :are_you_working,
      :last_permanent_residence_county,
      :homelessness_total_last_three_years,
      :health_insurance,
      :income_source_any,
      :income_source_earned_income,
      :income_source_ssdi,
      :income_source_ssi,
      :income_source_unemployment_insurance,
      :income_source_tanf,
      :income_source_child_support,
      :income_source_retirement,
      :income_source_alimony,
      :income_source_veteran_service_compensation,
      :income_source_general_assistance,
      {non_cash_benefits: []},
      client_attributes: [
        :first_name, 
        :last_name, 
        :date_of_birth, 
        :gender, 
        {race: []},
        :ethnicity,
        :phone_number,
        :email,
        :veteran,
        :veteran_military_branch,
        :veteran_separation_year,
        :veteran_discharge_status
      ],
      voucher: [
        :check_in,
        :check_out,
        :hotel_id
      ]
    )
  end

  def hydrate_form
    @disabled = []
    supply = RoomSupply.vouchers_remaining_today(@swap)
    @hotels = Hotel.all.reduce({}) do |memo, hotel|
      name = "#{hotel.name} (#{supply[hotel.id]})"
      if supply[hotel.id].to_i <= 0
        @disabled << hotel.id
      end
      memo.merge(Hash[name, hotel.id])
    end
  end
end
