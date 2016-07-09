require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "GET #index" do
    # let() = is not invoked and stored in memory until it is called
    # let!() = is invoked and stored in memory immediately, as if it is a before :each block
    let!(:projects) do
      create_list(:project, 3, :open, :with_tasks, number_of_tasks: 5)
      create_list(:project, 5, :done)
      create_list(:project, 2, :canceled)
    end

    let!(:index){ get :index, format: 'json' }
    let(:json){ JSON.parse(response.body) }

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
    let(:project){ create(:project, :open, :with_tasks) }
    let!(:show){ get :show, format: 'json', id: project }
    # don't invoke the json in a before block, it should be invoked when it is needed (e.g. to test the 404)
    let(:json){ JSON.parse(response.body) }

    context "when valid" do

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

    context "when invalid" do
      it "returns a 404 message" do
        get :show, format: 'json', id: 1
        expect(json['status']).to eq(404)
      end
    end

  end

  describe "POST #create" do

    let(:valid_params){ attributes_for(:project, :with_tasks) }
    let(:invalid_params){ attributes_for(:invalid_project) }
    let(:json){ JSON.parse(response.body) }

    context "when valid" do
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

    context "when invalid" do
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
    let(:project) { create(:project, :open) }
    let(:valid_params){ attributes_for(:project, :with_tasks) }
    let(:invalid_params){ attributes_for(:invalid_project) }

    context "when valid" do
      it "finds the requested project by its id" do
        # receive() with expect(); message expectation: object (Project) should receive a :message (from .find) during
        # execution of this code example
        # with(); expect message with an argument (project id)
        # and_call_original 'pass through' the received :message, in this case :find, to the original method
        # that is => Project.find(params[:id])
        # then the patch method can run successfully
        expect(Project).to receive(:find).with(project.id.to_s).and_call_original
        patch :update, format: 'json', id: project, project: valid_params
      end

      it "returns a 200 response" do
        patch :update, format: 'json', id: project, project: valid_params
        expect(response.status).to eq(200)
      end

      it "changes the project's attributes" do
        patch :update, format: 'json', id: project, project: valid_params
        json = JSON.parse(response.body)
        expect(json['project']['name']).to eq(valid_params[:name])
        expect(json['project']['description']).to eq(valid_params[:description])
        expect(json['project']['start_date']).to eq(valid_params[:start_date].to_s)
      end
    end

    context "when invalid" do

      it "does not change the project's attributes" do
        patch :update, format: 'json', id: project, project: invalid_params
        project.reload
        expect(project['name']).not_to eq(invalid_params['name'])
        expect(project['start_date']).not_to eq(invalid_params['start_date'])
      end

      it "returns a 422 message" do
        patch :update, format: 'json', id: project, project: invalid_params
        json = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(json['message']).to include("Could not update project")
      end
    end

  end

  describe "DELETE #destroy" do
    # using let!() here ensures that the :destroy test works. It fails if let() is used because the project isn't created yet
    let!(:project) { create(:project, :open) }
    let(:valid_params){ attributes_for(:project, :with_tasks) }
    let(:invalid_params){ attributes_for(:invalid_project) }

    context "when valid" do

      it "locates the requested project" do
        expect(Project).to receive(:find).with(project.id.to_s).and_call_original
        delete :destroy, format: 'json', id: project
      end

      it "deletes the project from the database" do
        expect{ delete :destroy, id: project }.to change(Project, :count).by(-1)
      end

      it "shows a confirmation message" do
        delete :destroy, id: project
        json = JSON.parse(response.body)
        expect(json['message']).to include("The project was successfully deleted")
      end

    end

    context "when invalid" do

      it "does not delete the project from the database" do
        project.id = 1
        expect{ delete :destroy, id: project }.not_to change(Project, :count)
      end

      it "returns an error if the project wasn't found" do
        project.id = 1
        delete :destroy, id: project
        json = JSON.parse(response.body)
        expect(json['status']).to eq(404)
      end

      it "returns an error if the project was not deleted" do
        # allow(); tell the object to return a value in response to a given :message (:find / :destroy)
        # and_return(project); method stub that returns the project object as value
        # and_return(false); method stub that returns false when :destroy is called
        allow(Project).to receive(:find).with(project.id.to_s).and_return(project)
        allow(project).to receive(:destroy).and_return(false)

        delete :destroy, id: project

        # after running the actual delete method, the aforementioned values are expected
        # and the else block in the controller is executed
        expect(Project).to have_received(:find)
        expect(project).to have_received(:destroy)

        json = JSON.parse(response.body)
        expect(json['message']).to include("Could not delete project")

      end

    end

  end

end
