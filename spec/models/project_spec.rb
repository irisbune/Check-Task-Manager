require 'rails_helper'
#circle CI / Travis CI

RSpec.describe Project, type: :model do

  let(:project) { build(:project) }

  describe "validations" do
    it "has a valid Factory" do
      # rails_helper includes FactoryGirl syntax config so we can just use build(:factory)
      # as opposed to FactoryGirl.build(:factory)
      expect(build(:project)).to be_valid
    end

    it "is invalid without a name" do
      project.name = nil
      project.valid?
      expect(project.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a status" do
      project.status = nil
      project.valid?
      expect(project.errors[:status]).to include("can't be blank")
    end

    it "is invalid when status isn't 'open', 'done' or 'canceled'" do
      project.status = "draft"
      project.valid?
      expect(project.errors[:status]).to include("is not a valid status")
    end

    it "is invalid without a start date" do
      project.start_date = nil
      project.valid?
      expect(project.errors[:start_date]).to include("can't be blank")
    end

    it "cannot have a start date in the past" do
      date = Date.yesterday
      project.start_date = date
      project.valid_start_date?
      expect(project.errors[:start_date]).to include("can't be in the past")
    end

    it "has a valid date when the format is yyyy-mm-dd" do
      date = "20 april"
      project.start_date = date
      project.valid?
      expect(project.errors[:start_date]).to include("format must be yyyy-mm-dd")
    end
  end

  describe "class methods" do

    let!(:projects) do
      create_list(:project, 4, :done, :with_tasks, number_of_tasks: 4, start_date: Date.tomorrow)
      create_list(:project, 3, :open, :in_same_month)
      create_list(:project, 2, :open, :in_past, :with_tasks)
      create_list(:project, 8, :done)
      create_list(:project, 7, :canceled)
    end

    context "status summary" do
      it "returns a hash of project statusses count" do
        expect(Project.project_status_count).to include('open' => 5, 'done' => 12, 'canceled' => 7)
      end

    end

    context "date filter" do
      it "returns an array of matched projects with a specific start date" do
        date = Date.tomorrow
        expect(Project.start_date_filter(date).count).to eq(4)
      end

      it "returns a sorted array of projects within the given start date range" do
        date_start = Date.new(2020,04,01)
        date_end = Date.new(2020,04,30)
        expect(Project.start_date_filter_range(date_start, date_end).count).to eq(3)
      end
    end
  end


end
