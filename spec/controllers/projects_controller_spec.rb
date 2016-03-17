require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "GET #index" do

      before :each do
        @open_projects = create_list(:project_with_tasks, 3, :open)
        @done_projects = create_list(:project, 5, :done)
        @canceled_projects = create_list(:project, 2, :canceled)
        get :index, format: 'json'
        @json = JSON.parse(response.body)
        # p @json
      end

      it "returns a 200 response" do
        expect(response.status).to eq(200)
        # or: expect(response).to be_success
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include('application/json')
      end

      it "lists all projects" do
        # p @all_projects.count
        # p @json['projects']
        expect(@json['projects'].count).to eq(10)
      end

      it "has a summary of all project statusses" do
        expect(@json['project_statusses']).to include('open'=> 3, 'done' => 5, 'canceled' => 2)
      end

      it "includes the tasks per project" do
        @json['projects'].each do |project|
          # p project['status']
          expect(project).to include('tasks')
        end
      end
  end

  describe "GET #show" do

    before :each do
      @project = create(:project_with_tasks, :open)
      get :show, format: 'json', id: @project
      @json = JSON.parse(response.body)
    end

    context "on success" do

      it "returns a 200 response" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include('application/json')
      end

      it "lists one project and its tasks" do
        expect(@json['project']).to include('tasks')
      end

      it "has a summary of all task statusses" do
        expect(@json['task_statusses']).to include('false'=> 4)
      end
    end

    context "on failure" do
      it "returns a 404 response" do
      end
    end

  end

  describe "POST #create" do
    it "saves a new project in the database"
    it "redirects to the new project's #show page"
    it "does not save the project to the database"
    it "returns an error message"
  end

  describe "PATCH #update" do
    it "locates the requested @project"
    it "changes the @project's attributes"
    it "redirects to the updated project"
    it "does not change the @project's attributes"
    it "returns an error message"
  end

  describe "DELETE #destroy" do
    it "locates the requested @project"
    it "deletes the @project from the database"
    it "does not delete the @project from the database"
    it "returns an error message"
  end

end
