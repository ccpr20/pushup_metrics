class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :email
  validate  :over_18, on: :create
  validates :terms_and_conditions, :acceptance => true

	has_many :pushups, :dependent => :destroy
	has_many :reminders, :dependent => :destroy
  accepts_nested_attributes_for :reminders, reject_if: proc { |attributes| attributes['phone_number'].blank? }

	has_and_belongs_to_many :teams
	accepts_nested_attributes_for :teams

  enum gender: {male: 0, female: 1, nonbinary: 2}
  def remember_me
    true
  end

  def total_pushups
    pushups.inject(0) { |sum, p| sum += p.amount }
  end

  def public_name
    "#{first_name} #{last_name.try(:first).nil? ? '' : (last_name[0] + '.')}".strip
  end

  def first_name
    name.split[0]
  end

  def last_name
    name.split[-1]
  end

  def most_recent_set
    pushups.order('date desc').first
  end

  def over_18
    if age + 18.years >= Date.today
      errors.add(:age, "You must be over 18 to signup.")
    end
  end
  def self.to_csv
    fields = ['name', 'company', 'company_website', 'email', 'created_at']

    CSV.generate(headers: true) do |csv|
      csv << fields

      all.each do |user|
        csv << user.attributes.values_at(*fields)
      end
    end
  end
end
