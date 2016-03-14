require 'rails_helper'

RSpec.describe Project, type: :model do

  it "is valid with a name, description and start date" do
    project = Project.new(
      name: "My project",
      description: "I have to practice RSpec",
      start_date: "2016/03/14"
    )
    expect(project).to be_valid
  end

  it "is invalid without a name" do
    project = Project.new(name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a start date" do
    project = Project.new(start_date: nil)
    project.valid?
    expect(project.errors[:start_date]).to include("can't be blank")
  end

  it "cannot have a start date in the past" do
    date = Date.yesterday
    project = Project.new(start_date: date)
    project.valid_start_date
    expect(project.errors[:start_date]).to include("Start date can't be in the past")
  end

  it "has a valid date when the format is mm/dd/yyyy"
  it "has an has_many association with tasks"


end
