class ProjectsController < ApplicationController

  def index
    projects = Project.all
    statusses = Project.project_status_count

    render json: {
      meta: {
        count: projects.count,
        page: 0
      },
      project_statusses: statusses,
      projects: projects.as_json({
          include: :tasks
        })
    }
  end

  def show
    project = Project.find(params[:id])
    task_statusses = project.tasks.status_count
    render json: {
      task_statusses: task_statusses,
      project: project.as_json({
        include: :tasks
        })
    }
  end

  def create
    project = Project.new(project_params)
    # by instantiating the project before saving it, enables testing the if and else blocks in the spec
    # project.create evaluates to true when params are invalid, because it can still instantiate the object
    # project.save evaluates to false when params are invalid, because it cannot save it to the db
    if project.save
      render json: { project: project }
    else
      render json: {
        message: "Could not create project",
        errors: project.errors
      }, status: :unprocessable_entity
    end
  end

  def update
    project = Project.find(params[:id])

    if project.update(project_params)
      render json: { project: project }
    else
      render json: {
        message: "Could not update project",
        errors: project.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    project = Project.find(params[:id])
    # if the project cannot be found, a json with 404 and error message is returned
    project.destroy
    # destroy returns the object that was destroyed but in 'frozen' state
    # destroyed? returns a boolean based on whether the object was destroyed or not
    if project.destroyed?
      render json: {
        project: nil,
        message: "The project was successfully deleted"
      }
    else
      render json: {
        message: "Could not delete project",
      }, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :start_date, :status)
  end
end
