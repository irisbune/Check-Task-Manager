require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "GET #index" do
    it "returns a 200 response"
    it "returns json"
    it "lists all projects"
    it "has a summary of all project statusses"
    it "includes the tasks per project"
    it "renders the :index template"
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
