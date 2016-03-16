require 'rails_helper'

RSpec.describe Project, type: :model do

  describe "validations" do
    it "has a valid Factory" do
      # rails_helper includes FactoryGirl syntax config so we can just use build(:factory)
      # as opposed to FactoryGirl.build(:factory)
      expect(build(:project)).to be_valid
    end

    it "is invalid without a name" do
      # project = Project.new(name: nil)
      project = build(:project, name: nil)
      project.valid?
      expect(project.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a status" do
      # project = Project.new(status: nil)
      project = build(:project, status: nil)
      project.valid?
      expect(project.errors[:status]).to include("can't be blank")
    end

    it "is invalid when status isn't 'open', 'done' or 'canceled'" do
      # project = Project.new(status: "draft")
      project = build(:project, status: "draft")
      project.valid?
      expect(project.errors[:status]).to include("is not a valid status")
    end

    it "is invalid without a start date" do
      # project = Project.new(start_date: nil)
      project = build(:project, start_date: nil)
      project.valid?
      expect(project.errors[:start_date]).to include("can't be blank")
    end

    it "cannot have a start date in the past" do
      date = Date.yesterday
      # project = Project.new(start_date: date)
      project = build(:project, start_date: date)
      project.valid_start_date?
      expect(project.errors[:start_date]).to include("can't be in the past")
    end

    it "has a valid date when the format is yyyy-mm-dd" do
      date = "20 april"
      # project = Project.new(start_date: date)
      project = build(:project, start_date: date)
      project.valid?
      expect(project.errors[:start_date]).to include("format must be yyyy-mm-dd")
    end
  end

  describe "class methods" do
    before :each do
      @project1 = create(:project, start_date: Date.tomorrow, status: "done")
      @project2 = create(:project, start_date: Date.tomorrow, status: "done")
      @project3 = create(:project, start_date: Date.new(2016,04,01))
      @project4 = create(:project, start_date: Date.new(2016,04,10), status: "canceled")
      @project5 = create(:project, start_date: Date.new(2016,04,20))
      @project6 = create(:project, start_date: Date.new(2016,07,20))
      @project7 = create(:project, start_date: Date.yesterday)
      @task1 = create(:task, project: @project1)
      @task2 = create(:task, project: @project1)
      @task3 = create(:task, project: @project2)
      @task4 = create(:task, project: @project6)
      @task5 = create(:task, project: @project7)
    end

    context "status summary" do
      it "gives a hash of the nr of project statusses" do
        expect(Project.project_status_count).to include('open' => 4, 'done' => 2, 'canceled' => 1)
      end

    end

    context "date filters" do
      it "returns an array of matched projects with a specific start date" do
        date = Date.tomorrow
        expect(Project.start_date_filter(date)).to eq [@project1, @project2]
      end

      it "returns a sorted array of projects within the given start date range" do
        date_start = Date.new(2016,04,01)
        date_end = Date.new(2016,04,30)
        expect(Project.start_date_filter_range(date_start, date_end)).to eq [@project3, @project4, @project5]
      end
    end
  end


end
