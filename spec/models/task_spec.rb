require 'rails_helper'

RSpec.describe Task, type: :model do

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

  describe "class methods" do
    before :each do
      @task = create(:task, duedate: Date.new(2016,05,10), status: true)
      @task2 = create(:task, duedate: Date.new(2016,10,10))
      @task3 = create(:task, duedate: Date.new(2016,05,10))
      @task4 = create(:task, duedate: Date.new(2016,04,02), status: true)
      @task5 = create(:task, duedate: Date.new(2018,04,02))
      @task6 = create(:task, duedate: Date.new(2016,07,20))
      @task7 = create(:task, duedate: Date.new(2018,02,12))
    end
    context "status summary" do
      it "shows the total number of open tasks" do
        expect(Task.done).to eq 2
      end
      it "shows the total number of completed tasks" do
        expect(Task.not_done).to eq 5
      end
    end

    context "date filters" do
      it "returns an array of tasks on a specific date" do
        date = Date.new(2016,05,10)
        expect(Task.duedate_filter(date)).to eq [@task, @task3]
      end

      it "returns an array of tasks within a given date range" do
        date_start = Date.new(2016,10,01)
        date_end = Date.new(2018,05,01)
        expect(Task.duedate_filter_range(date_start, date_end)).to eq [@task2, @task5, @task7]
      end
    end
  end

end
