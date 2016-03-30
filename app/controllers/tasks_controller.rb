class TasksController < ApplicationController
  before_action :set_project


  def create
    task = Task.new(task_params)
    
    if task.save
      render json: { task: task }
    else
      render json: {
        message: "Could not create Task",
        errors: task.errors,
      }, status: :unprocessible_entity
    end
  end

  def update
    task = Task.find(params[:id])

    if task.update(task_params)
      render json: { task: task }
    else
      render json: {
        message: "Could not update Task",
        errors: task.errors,
      }, status: :unprocessible_entity
    end
  end

  def destroy
    task = Task.find(params[:id])

    if task.destroy
      render json: { task: nil }
    else
      render json: {
        message: "Could not destroy Task, please try again",
      }, status: :unprocessible_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:task_description, :duedate, :status, :project_id)
  end
end
