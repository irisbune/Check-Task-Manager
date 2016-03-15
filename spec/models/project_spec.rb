require 'rails_helper'

RSpec.describe Project, type: :model do

  it "is valid with a name, description, status and start date" do
    project = Project.new(
      name: "My project",
      description: "I have to practice RSpec",
      status: "open",
      start_date: Date.today
    )
    expect(project).to be_valid
  end

  it "is invalid without a name" do
    project = Project.new(name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a status" do
    project = Project.new(status: nil)
    project.valid?
    expect(project.errors[:status]).to include("can't be blank")
  end

  it "is invalid when status isn't 'open', 'done' or 'canceled'" do
    project = Project.new(status: "draft")
    project.valid?
    expect(project.errors[:status]).to include("is not a valid status")
  end

  it "is invalid without a start date" do
    project = Project.new(start_date: nil)
    project.valid?
    expect(project.errors[:start_date]).to include("can't be blank")
  end

  it "cannot have a start date in the past" do
    date = Date.yesterday
    project = Project.new(start_date: date)
    project.valid_start_date?
    expect(project.errors[:start_date]).to include("can't be in the past")
  end

  it "has a valid date when the format is yyyy-mm-dd" do
    date = "20 april"
    project = Project.new(start_date: date)
    project.valid?
    expect(project.errors[:start_date]).to include("format must be yyyy-mm-dd")
  end

  describe "project status summary" do
    before :each do
      project1 = Project.create(
        name: "No tasks",
        description: "I have to practice RSpec",
        status: "open",
        start_date: Date.today
      )
      project2 = Project.create(
        name: "My second project",
        description: "I have to practice RSpec more more",
        status: "open",
        start_date: Date.tomorrow
      )
      project3 = Project.create(
        name: "My 3rd project",
        description: "I have to practice RSpec more more",
        status: "done",
        start_date: Date.tomorrow
      )
      project4 = Project.create(
        name: "Another no tasks",
        description: "I have to practice RSpec more more",
        status: "canceled",
        start_date: Date.tomorrow
      )
      task1 = project2.tasks.create(
        task_description: "Something to do",
        duedate: Date.tomorrow
      )
      task2 = project3.tasks.create(
        task_description: "Something to do",
        duedate: Date.tomorrow
      )
      task3 = project3.tasks.create(
        task_description: "Something to do",
        duedate: Date.tomorrow
      )
    end
    it "gives the total nr of open projects" do
      expect(Project.total_open_projects).to eq 2
    end
    it "gives the total nr of done projects" do
      expect(Project.total_done_projects).to eq 1
    end
    it "gives the total nr of canceled projects" do
      expect(Project.total_canceled_projects).to eq 1
    end
    it "gives the total nr of projects without a task" do
      expect(Project.taskless_projects).to eq 2
    end
  end

  describe "project start date filter" do
    before :each do
      @project1 = Project.create(
        name: "My project",
        description: "I have to practice RSpec",
        status: "open",
        start_date: Date.today
      )
      @project2 = Project.create(
        name: "My second project",
        description: "I have to practice RSpec more more",
        status: "open",
        start_date: Date.tomorrow
      )
      @project3 = Project.create(
        name: "My 3rd project",
        description: "I have to practice RSpec more more",
        status: "done",
        start_date: Date.tomorrow
      )
      @project4 = Project.create(
        name: "My 3rd project",
        description: "I have to practice RSpec more more",
        status: "canceled",
        start_date: Date.new(2016,04,01)
      )
      @project5 = Project.create(
        name: "My 3rd project",
        description: "I have to practice RSpec more more",
        status: "canceled",
        start_date: Date.new(2016,04,06)
      )
    end
    context "specific" do
      it "returns an array of matched projects with a specific start date" do
        date = Date.tomorrow
        expect(Project.start_date_filter(date)).to eq [@project2, @project3]
      end
    end
    context "range" do
      it "returns a sorted array of projects within the given start date range" do
        date_start = Date.new(2016,04,01)
        date_end = Date.new(2016,04,30)
        expect(Project.start_date_filter_range(date_start, date_end)).to eq [@project4, @project5]
      end
    end
  end


end
