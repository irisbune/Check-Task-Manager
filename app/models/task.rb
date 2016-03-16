class Task < ActiveRecord::Base
  belongs_to :project, required: true
  validates :task_description, :duedate, presence: true
  # validate status by excluding 'nil' by checking values true/false in array
  validates_inclusion_of :status, in: [true, false], message: "can't be blank or anything other than true/false"
  validates_format_of :duedate, with: /\d{4}-\d{2}-\d{2}/, :message => "must be in the following format: yyyy-mm-dd"

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

  def self.done
    return where(status: true).count
  end

  def self.not_done
    return where(status: false).count
  end

end
