require 'csv'

class Admin::ReportsController < Admin::BaseController
  def vouchers
    csv =
      CSV.generate(headers: true) do |csv|
        csv << %w[
          voucher_number
          voucher_check_in
          voucher_check_out
          voucher_issued_date
          voucher_issued_time
          voucher_issued_by
          voucher_voided_at
          voucher_voided_by
          voucher_hotel_name
          client_first_name
          client_last_name
          client_date_of_birth
          client_hmis_id
          client_gender
          client_phone_number
          client_email
          client_race
          client_ethnicity
          client_short_intake_what_city_did_you_sleep_in_last_night
          voucher_guests
          client_intake_county_eligibility
        ]

        Voucher
          .includes(:issuer, :voided_by, :hotel, client: [:short_intakes])
          .order(id: :asc)
          .find_each do |voucher|
            csv << [
              voucher.number,
              voucher.check_in,
              voucher.check_out,
              voucher.created_at.to_date.to_s,
              voucher.created_at.strftime('%r'),
              voucher.issuer&.name,
              voucher.voided_at,
              voucher.voided_by&.name,
              voucher.hotel&.name,
              voucher.client&.first_name,
              voucher.client&.last_name,
              voucher.client&.date_of_birth,
              voucher.client&.hmis_id,
              voucher.client&.gender,
              voucher.client&.phone_number,
              voucher.client&.email,
              voucher.client&.race&.join(','),
              voucher.client&.ethnicity,
              voucher.client.short_intakes.last&.what_city_did_you_sleep_in_last_night,
              format_guests(voucher.guests),
              voucher.client.intakes.last&.county_eligibility,
            ]
          end
      end

    respond_to do |format|
      format.csv do
        send_data csv, filename: "vouchers-#{Time.zone.now.iso8601}.csv"
      end
    end
  end

  def format_guests(guests)
    guests.map { |guest| "#{guest.name} - #{guest.date_of_birth}" }.join(', ')
  end

  def red_flags
    csv =
      CSV.generate(headers: true) do |csv|
        csv << %w[
          client_last_name
          client_first_name
          client_date_of_birth
          hotel_id
          hotel_name
          created_at
        ]

        RedFlag
          .includes(:client, :hotel)
          .order('clients.last_name asc, hotels.id asc')
          .find_each do |red_flag|
            csv << [
              red_flag.client&.last_name,
              red_flag.client&.first_name,
              red_flag.client&.date_of_birth,
              red_flag.hotel&.id,
              red_flag.hotel&.name,
              red_flag.created_at.in_time_zone,
            ]
          end
      end

    respond_to do |format|
      format.csv do
        send_data csv, filename: "red_flags-#{Time.zone.now.iso8601}.csv"
      end
    end
  end
end
