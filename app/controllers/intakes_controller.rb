class IntakesController < ApplicationController
  def new
    @client =
      params[:client_id].present? ? Client.find(params[:client_id]) : Client.new
    @intake = Intake.new
    @voucher = Voucher.new
  end

  def create
    client_params = intake_params[:client_attributes]

    @client =
      if client_params[:client_id]
        Client.find(client_params[:client_id])
      elsif client_params[:id].present?
        Client.find(client_params[:id])
      else
        Client.new
      end

    profile_photo_data_url = intake_params.delete(:camera)
    @client.assign_attributes(
      client_params.merge(
        veteran: !!client_params[:veteran],
        veteran_separation_year:
          client_params[:veteran_separation_year].presence,
        family_members:
          params
            .dig(:intake, :client_attributes, :family_members)
            &.permit!
            &.to_h || {},
        force_intake: false,
      ),
    )
    @intake =
      Intake.new(
        intake_params
          .except(:camera, :voucher, :client_attributes)
          .merge(
            swap_id: @swap.id,
            user_id: current_user.id,
            # client_id: @client.id,
            client: @client,
            household_tanf: !!intake_params[:household_tanf],
            have_you_ever_experienced_homelessness_before:
              !intake_params[:homelessness_first_time],
            # non_cash_benefits: intake_params[:non_cash_benefits].reject { |r| r == '0' },
            income_source_any: !!intake_params[:income_source_any],
            active_duty: !!intake_params[:active_duty],
            chronic_health_condition:
              !!intake_params[:chronic_health_condition],
            mental_health_disability:
              !!intake_params[:mental_health_disability],
            physical_disability: !!intake_params[:physical_disability],
            developmental_disability:
              !!intake_params[:developmental_disability],
            fleeing_domestic_violence:
              !!intake_params[:fleeing_domestic_violence],
          ),
      )

    if profile_photo_data_url.present?
      # The data is Base64 and coming from the camera.
      # Use that data to create a file for active storage.
      # data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD....
      blob =
        ActiveStorage::Blob.create_after_upload!(
          io:
            StringIO.new(
              (Base64.decode64(profile_photo_data_url.split(',')[1] || '')),
            ),
          filename: 'profile_photo.jpeg',
          content_type: 'image/jpeg',
        )

      @client.profile_photo.attach(blob)
    end

    return render :new if (!@client.validate || !@intake.save)

    redirect_to new_voucher_path(
                  client_id: @client.id,
                  unsheltered_tonight: true,
                )
  end

  private

  def intake_params
    params
      .require(:intake)
      .permit(
        :camera,
        :homelessness_first_time,
        :homelessness_date_began,
        :homelessness_episodes_last_three_years,
        :where_did_you_sleep_last_night,
        :household_tanf,
        { why_not_shelter: [] },
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
        :county_eligibility,
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
        { non_cash_benefits: [] },
        client_attributes: [
          :id,
          :profile_photo,
          :first_name,
          :last_name,
          :date_of_birth,
          :hmis_id,
          :gender,
          { race: [] },
          :ethnicity,
          :phone_number,
          :email,
          :veteran,
          :veteran_military_branch,
          :veteran_separation_year,
          :veteran_discharge_status,
        ],
      )
  end
end
