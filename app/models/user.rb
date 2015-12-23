class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :email

	has_many :pushups
	has_many :reminders
	has_and_belongs_to_many :teams
	accepts_nested_attributes_for :teams

end
