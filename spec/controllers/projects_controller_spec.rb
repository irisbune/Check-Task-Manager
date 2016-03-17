require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "GET #index" do

    context "on success" do

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

  end

  describe "GET #show" do
    it "returns a 200 response"
    it "returns json"
    it "lists one project and its tasks"
    it "has a summary of all task statusses"
    it "renders the :show template"
  end

  describe "GET #new" do
    it "assigns a new Project to @project"
    it "renders the :new template"
  end

  describe "POST #create" do
    it "saves a new project in the database"
    it "redirects to the new project's #show page"
    it "does not save the project to the database"
    it "re-renders the :new page"
  end

  describe "GET #edit" do
    it "assigns the requested project to @project"
    it "renders the :edit template"
  end

  describe "PATCH #update" do
    it "locates the requested @project"
    it "changes the @project's attributes"
    it "redirects to the updated project"
    it "does not change the @project's attributes"
    it "re-renders the :edit template"
  end

  describe "DELETE #destroy" do
    it "locates the requested @project"
    it "deletes the @project from the database"
    it "redirects to the :index template"
  end

end
