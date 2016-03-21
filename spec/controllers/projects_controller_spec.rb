require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "GET #index" do

    let!(:projects) do
      create_list(:project_with_tasks, 3, :open)
      create_list(:project, 5, :done)
      create_list(:project, 2, :canceled)
    end

    let!(:index){ get :index, format: 'json' }
    let!(:json){ JSON.parse(response.body) }

      it "returns a 200 response" do
        expect(response.status).to eq(200)
        # or: expect(response).to be_success
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include('application/json')
      end

      it "lists all projects" do
        # p json
        expect(json['projects'].count).to eq(10)
      end

      it "has a summary of all project statusses" do
        expect(json['project_statusses']).to include('open'=> 3, 'done' => 5, 'canceled' => 2)
      end

      it "includes the tasks per project" do
        json['projects'].each do |project|
          # p project['status']
          expect(project).to include('tasks')
        end
      end
  end

  describe "GET #show" do
    # using 'id: project' in let!(:show), invokes let(:project)
    let(:project){ create(:project_with_tasks, :open) }
    let!(:show){ get :show, format: 'json', id: project }
    # don't fun the json in a before block, it should be invoked when it is needed (e.g. to test the 404)
    let(:json){ JSON.parse(response.body) }

    context "on success" do

      it "returns a 200 response" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include('application/json')
      end

      it "lists one project and its tasks" do
        expect(json['project']).to include('tasks')
      end

      it "has a summary of all task statusses" do
        expect(json['task_statusses']).to include('false'=> 4)
      end
    end

    context "on failure" do
      it "returns a 404 message" do
        get :show, format: 'json', id: 1
        expect(json['status']).to eq(404)
      end
    end

  end

  describe "POST #create" do

    let(:valid_params){ attributes_for(:project_with_tasks) }
    let(:invalid_params){ attributes_for(:invalid_project) }
    let(:json){ JSON.parse(response.body) }

    context "on success" do
      it "saves a new project in the database" do
        expect{post :create,
                    format: 'json',
                    project: valid_params}.to change(Project, :count).by(1)
      end

      it "returns the new project" do
        post :create, format: 'json', project: valid_params
        expect(json['project']['name']).to eq(valid_params[:name])
        expect(json['project']['description']).to eq(valid_params[:description])
        expect(json['project']['start_date']).to eq(valid_params[:start_date].to_s)
      end
    end

    context "on failure" do
      it "does not save the project to the database" do
        expect{post :create,
                    format: 'json',
                    project: invalid_params}.not_to change(Project, :count)
      end

      it "returns an error message" do
        # how do you test the error message that should be rendered if create == false in controller?
        post :create, format: 'json', project: invalid_params
        # p response.committed?
        expect(response.status).to eq(422)
      end
    end

  end

  describe "PATCH #update" do
    # let() = is not invoked and stored in memory until it is called
    # let!() = is invoked and stored in memory immediately, as if it is a before :each block
    let!(:project) { create(:project, :open) }
    let(:valid_params){ attributes_for(:project_with_tasks) }
    let(:invalid_params){ attributes_for(:invalid_project) }

    context "on success" do
      it "locates the requested project" do
        expect(Project).to receive(:find).with(project.id.to_s).and_call_original
        # receive()
        # with()
        # and_call_original
        patch :update, format: 'json', id: project, project: valid_params
      end

      it "returns a 200 response" do

      end

      it "changes the project's attributes" do
        patch :update, format: 'json', id: project, project: valid_params
        json = JSON.parse(response.body)
        expect(json['project']['name']).to eq(valid_params[:name])
        expect(json['project']['description']).to eq(valid_params[:description])
        expect(json['project']['start_date']).to eq(valid_params[:start_date].to_s)
      end
    end

    context "on failure" do
      it "does not change the project's attributes"
      it "returns an error message"
    end

  end

  describe "DELETE #destroy" do
    it "locates the requested project"
    it "deletes the project from the database"
    it "does not delete the project from the database"
    it "returns an error message"
  end

end
