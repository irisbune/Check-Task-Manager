require 'rails_helper'

RSpec.describe Task, type: :model do

  # describe "validations" do
  #   it { is_expected.to validate_presence_of(:task_description) }
  #   it { is_expected.to validate_presence_of(:duedate) }
  # end
  #
  # describe "allowed values for duedate" do
  #   it { should allow_value(Date.tomorrow).for(:duedate) }
  #   it { should_not allow_value(1.days.ago).for(:duedate) }
  # end

  describe "validations" do
    it "has a valid Factory" do
      expect(build(:task)).to be_valid
    end

    it "is invalid without a task description" do
      task = build(:task, task_description: nil)
      task.valid?
      expect(task.errors[:task_description]).to include("can't be blank")
    end

    it "is invalid without a duedate" do
      task = build(:task, duedate: nil)
      task.valid?
      expect(task.errors[:duedate]).to include("can't be blank")
    end

    it "is invalid with a duedate in the past" do
      task = build(:task, duedate: Date.yesterday)
      task.valid?
      expect(task.errors[:duedate]).to include("can't be in the past")
    end

    it "is invalid without a status boolean" do
      task = build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank or anything other than true/false")
    end

    it "is invalid without a project" do
      task = build(:task, project_id: nil)
      task.valid?
      expect(task.errors[:project_id]).to include("Project does not exist")
    end

  end

  it "has a status summary"
  it "has a due date filter"

end
