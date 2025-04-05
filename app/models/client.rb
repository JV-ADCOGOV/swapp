class Client < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :that_sounds_like,
                  against: %i[first_name last_name],
                  using: :dmetaphone

  GENDER = [
    'Female',
    'Male',
    'Trans Female (MTF)',
    'Trans Male (FTM)',
    'Gender Non-Conforming',
    "Client Doesn't Know",
    'Client Refused',
  ]

  RACE = [
    'American Indian, Alaska Native, or Indigenous',
    'Asian or Asian American',
    'Black, African American, or African',
    'Hispanic/Latina/e/o',
    'Middle Eastern or North African',
    'Native Hawaiian or Pacific Islander',
    'White',
    "Client doesn't know",
    'Client prefers not to answer',
    'Data not collected',
  ]

  ETHNICITY = ['Not Hispanic or Latino', 'Hispanic or Latino']

  auto_strip_attributes :first_name, :last_name, :race, :phone_number, :email

  validates :first_name, :last_name, :date_of_birth, presence: true
  validates :gender, inclusion: { in: Client::GENDER, allow_nil: true }
  validates :ethnicity, inclusion: { in: Client::ETHNICITY, allow_nil: true }
  validates :hmis_id,
            uniqueness: true,
            allow_nil: true,
            length: {
              is: 9,
            },
            format: {
              with: /[A-Za-z0-9]+/,
            }

  # validate :accepted_race_values
  # validates :phone_number, phone: { possible: true, allow_nil: true }
  # validates_format_of :email, with: Devise.email_regexp, allow_nil: true

  has_many :intakes
  has_many :short_intakes
  has_many :vouchers
  has_many :incident_reports
  has_many :red_flags, class_name: 'RedFlag'
  has_many :flagged_hotels, through: :red_flags, source: :hotel
  has_one_attached :profile_photo

  # Callbacks
  before_save { self.race = self&.race&.reject { |r| r == '0' } }

  def name
    "#{first_name} #{last_name}"
  end

  def prior_guests
    vouchers.flat_map(&:guests).uniq
  end

  # ban client from the program entirely
  def ban!
    update(banned: true)
  end

  # remove program-wide ban
  def unban!
    update(banned: false)
  end

  # ban client from specific hotel
  def ban_at!(hotel)
    return false if existing_flag = red_flags.find_by(hotel: hotel)
    red_flags.create(hotel: hotel)
  end

  # remove hotel-specific ban
  def unban_at!(hotel)
    return false unless existing_flag = red_flags.find_by(hotel: hotel)
    existing_flag.destroy!
  end

  def partial_ban?
    !banned && red_flags.any?
  end

  def no_flags?
    !banned && red_flags.empty?
  end

  def current_voucher
    vouchers.active.where(swap: Swap.current).last
  end

  def has_received_voucher_this_swap_period?
    !current_voucher.nil?
  end
end
