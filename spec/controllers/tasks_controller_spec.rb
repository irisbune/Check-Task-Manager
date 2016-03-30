require 'rails_helper'


RSpec.describe TasksController, type: :controller do

  # Only create, update, delete is needed for tasks

  describe "POST #create" do

    let(:project){ create(:project) }
    let(:valid_params){ attributes_for(:task, project_id: project.id) }
    let(:invalid_params){ attributes_for(:invalid_task, project_id: project.id) }
    let(:json){ json = JSON.parse(response.body) }

    context "when valid" do

      it "returns a 200 status" do
        post :create, format: 'json', task: valid_params, project_id: project.id
        expect(response.status).to eq(200)
      end

      it "returns a json" do
        post :create, format: 'json', task: valid_params, project_id: project.id
        # p response.header
        expect(response.header['Content-Type']).to include('application/json')
      end

      it "saves the task to the database" do
        expect{post :create,
               format: 'json',
               task: valid_params,
               project_id: project.id}.to change(Task, :count)
      end

      it "renders the new task" do
        post :create, format: 'json', task: valid_params, project_id: project.id
        expect(json['task']['task_description']).to eq(valid_params[:task_description])
        expect(json['task']['duedate']).to eq(valid_params[:duedate].to_s)
        expect(json['task']['project_id']).to eq(valid_params[:project_id])
      end

    end

    context "when invalid" do

      it "returns a 422 status" do

      end
      
      it "does not save the task to the database"
      it "renders an error message"
    end

  end

  describe "PATCH #update" do

    context "when valid" do
      it "finds the requested task by its id"
      it "returns a 200 status"
      it "updates the tasks in the database with the new params"
      it "renders the task with the updated params"
    end

    context "when invalid" do
      it "returns a 404"
      it "does not update the task in the database with invalid params"
      it "renders an error message"
    end

  end

  describe "DELETE #destroy" do

    context "when valid" do
      it "finds the requested task by its id"
      it "returns a 200 status"
      it "deletes the task from the database"
      it "renders the tasklist without the deleted task"
    end

    context "when invalid" do
      it "returns a 404"
      it "renders an error message"
    end

  end

end
