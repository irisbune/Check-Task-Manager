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
    render json: { project: project }
  end

  def create
    if project = Project.create(project_params)
      render json: { project: project }
    else
      render json: {
        message: "Could not create project",
        errors: project.errors,
      }, status: :unprocessible_entity
    end
  end

  def update
    project = Project.find(params[:id])

    if project.update(project_params)
      render json: { project: project }
    else
      render json: {
        message: "Could not update project",
        errors: project.errors,
      }, status: :unprocessible_entity
    end
  end

  def destroy
    project = Project.find(params[:id])

    if project.destroy
      render json: { project: nil }
    else
      render json: {
        message: "Could not destroy project, please try again",
      }, status: :unprocessible_entity
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
