class Task < ActiveRecord::Base
  belongs_to :project, required: true

  validates :task_description, presence: true
  validates :duedate, format: { with: /\d{4}-\d{2}-\d{2}/,
                                message: "format must be yyyy-mm-dd"},
                                presence: true
  # validate status by excluding 'nil' by checking values true/false in array

  validates :status, inclusion: { in: [true, false],
                                  message: "can't be blank or anything other than true/false"}

  validate :valid_date
  validate :valid_project

  private

  def valid_date
    if duedate.present? && duedate < Date.today
      errors.add(:duedate, "can't be in the past")
    end
  end

  def valid_project
    unless Project.exists?(project_id)
      errors.add(:project_id, "Project does not exist")
    end
  end

  def self.duedate_filter(date)
    return where(duedate: date)
  end

  def self.duedate_filter_range(date_start, date_end)
    return where(duedate: date_start..date_end)
  end

  def self.status_count
    return group(:status).count
  end

end
