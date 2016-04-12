require 'rails_helper'

RSpec.describe Task, type: :model do

  describe "validations" do

    let(:task){ build(:task) }
    let(:invalid_task){ build(:invalid_task) }
    let(:task_in_past){ build(:task, :in_past) }

    it "has a valid Factory" do
      expect(build(:task)).to be_valid
    end

    it "is invalid without a task description" do
      invalid_task.valid?
      expect(invalid_task.errors[:task_description]).to include("can't be blank")
    end

    it "is invalid without a duedate" do
      invalid_task.valid?
      expect(invalid_task.errors[:duedate]).to include("can't be blank")
    end

    it "is invalid with a duedate in the past" do
      task_in_past.valid?
      expect(task_in_past.errors[:duedate]).to include("can't be in the past")
    end

    it "is invalid without a status boolean" do
      invalid_task.status = nil
      invalid_task.valid?
      expect(invalid_task.errors[:status]).to include("can't be blank or anything other than true/false")
    end

    it "is invalid without a project" do
      invalid_task.project_id = nil
      invalid_task.valid?
      expect(invalid_task.errors[:project_id]).to include("Project does not exist")
    end

  end

  describe "class methods" do

    let!(:tasks) do
      create_list(:task, 4, :completed)
      create_list(:task, 2, :tomorrow)
    end

    context "status summary" do
      it "returns a hash of task statusses count" do
        expect(Task.status_count).to include(true => 4, false => 2)
      end
    end

    context "date filters" do
      it "returns an array of tasks on a specific date" do
        date = Date.tomorrow
        expect(Task.duedate_filter(date).count).to eq(2)
      end

      it "returns an array of tasks within a given date range" do
        date_start = Date.today
        date_end = 30.days.from_now
        expect(Task.duedate_filter_range(date_start, date_end).count).to eq(6)
      end
    end
  end

end
