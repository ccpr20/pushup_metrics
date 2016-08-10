class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :email

	has_many :pushups, :dependent => :destroy
	has_many :reminders, :dependent => :destroy
  accepts_nested_attributes_for :reminders, reject_if: proc { |attributes| attributes['phone_number'].blank? }

	has_and_belongs_to_many :teams
	accepts_nested_attributes_for :teams

  def remember_me
    true
  end

end
