class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :start_date, format: { with: /\d{4}-\d{2}-\d{2}/,
                                   message: "format must be yyyy-mm-dd"},
                                   presence: true
  validates :status, inclusion: { in: ["open", "done", "canceled"],
                                  message: "is not a valid status"},
                                  presence: true

  def valid_start_date?
    if start_date.present? && start_date.past?
      errors.add(:start_date, "can't be in the past")
    end
  end

  def self.total_open_projects
    return where(status: "open").count
  end

  def self.total_done_projects
    return where(status: "done").count
  end

  def self.total_canceled_projects
    return where(status: "canceled").count
  end

  def self.taskless_projects
    return includes(:tasks).where(:tasks => {project_id: nil}).count
  end

  def self.start_date_filter(date)
    return where(start_date: date)
  end

  def self.start_date_filter_range(date_start, date_end)
    return where(start_date: date_start..date_end)
  end

end
