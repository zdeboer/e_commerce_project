class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  validates :first_name, :last_name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[first_name last_name email phone created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[addresses orders]
  end
end
