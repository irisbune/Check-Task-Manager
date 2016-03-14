class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy

  validates :name, :start_date, presence: true

  def valid_start_date
    if start_date.present? && start_date.past?
      errors.add(:start_date, "Start date can't be in the past")
    end
  end


end
