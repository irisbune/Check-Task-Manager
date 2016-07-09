class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :start_date, format: { with: /\d{4}-\d{2}-\d{2}/,
                                   message: "format must be yyyy-mm-dd"},
                                   presence: true
  validates :status, inclusion: { in: ["open", "done", "canceled"],
                                  message: "is not a valid status"},
                                  presence: true

private

  def valid_start_date?
    if start_date.present? && start_date.past?
      errors.add(:start_date, "can't be in the past")
    end
  end

  def self.project_status_count
    return group(:status).count
  end

  def self.taskless_projects
    # return includes(:tasks).where(:tasks => {project_id: nil}).count
    # return joins("LEFT OUTER JOIN tasks ON tasks.project_id = projects.id").where("tasks.project_id IS NULL").count

    # pluck() returns an array of values from the specified column(s), in this case project_id from the tasks table.
    # The total count of project id's that do not exist in this array are returned.
    return where.not(id: Task.pluck(:project_id)).count
  end

  def self.start_date_filter(date)
    return where(start_date: date)
  end

  def self.start_date_filter_range(date_start, date_end)
    return where(start_date: date_start..date_end)
  end

end
