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

  it "gives the total nr of open projects" do
    project = Project.create(
      name: "My project",
      description: "I have to practice RSpec",
      status: "open",
      start_date: Date.today
    )
    another_project = Project.create(
      name: "My second project",
      description: "I have to practice RSpec more more",
      status: "open",
      start_date: Date.tomorrow
    )
    expect(Project.total_open_projects).to eq 2
  end

  it "gives the total nr of done projects" do
    project = Project.create(
      name: "My project",
      description: "I have to practice RSpec",
      status: "done",
      start_date: Date.today
    )
    another_project = Project.create(
      name: "My second project",
      description: "I have to practice RSpec more more",
      status: "open",
      start_date: Date.tomorrow
    )
    expect(Project.total_done_projects).to eq 1
  end

  it "gives the total nr of canceled projects" do
    project = Project.create(
      name: "My project",
      description: "I have to practice RSpec",
      status: "canceled",
      start_date: Date.today
    )
    another_project = Project.create(
      name: "My second project",
      description: "I have to practice RSpec more more",
      status: "canceled",
      start_date: Date.tomorrow
    )
    expect(Project.total_canceled_projects).to eq 2
  end

  it "gives the total nr of projects without a task" do
    project = Project.create(
      name: "My project",
      description: "I have to practice RSpec",
      status: "open",
      start_date: Date.today
    )
    another_project = Project.create(
      name: "My second project",
      description: "I have to practice RSpec more more",
      status: "open",
      start_date: Date.tomorrow
    )
    another_project_task = another_project.tasks.create(
      task_description: "Something to do",
      duedate: Date.tomorrow
    )
    expect(Project.taskless_project).to eq 1
  end


end
