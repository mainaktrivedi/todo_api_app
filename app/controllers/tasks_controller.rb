class TasksController < ApplicationController

  include TaskHelper
	# GET /tasks
	# GET /tasks.json
	def index
    @tasks = Task.includes(:tags).all
    render json: @tasks, status: 200
  end
	# GET /tasks/1
	# GET /tasks/1.json
  def show
    render json: task, status: 200
  end

	# POST /tasks
	# POST /tasks.json
	def create
	  @task = Task.new(task_params)
    #just playing
    #add_c_suffix(@task)
    if @task.save
      render json: @task, status: :created
    else
      render json: {errors: @task.errors}, status: :unprocessable_entity
    end
	end

    # PATCH/PUT /tasks/1
    # PATCH/PUT /tasks/1.json
  def update
    ActiveRecord::Base.transaction do
      if task.update(task_params)
        unless tag_params[:tags].nil? || tag_params[:tags].count == 0
          tag_params[:tags].each do |tag_title|
            tg = Tag.where(title: tag_title).first_or_create
            task.tags << tg
          end
          task.save!
        end
        render json: task, status: :ok
      else
        render json: {errors: task.errors}, status: :unprocessable_entity
      end
    end
  end

    # DELETE /tasks/1
    # DELETE /tasks/1.json
  def destroy
    task = Task.includes(:tags).find(params[:id])
    if !task.blank?
      task.destroy
      render json: {}, status: :no_content
    else
      render json: {}, status: 404
    end
  end

  private

  def task
    @task ||= Task.includes(:tags).find(params[:id])
  end

  def task_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:title])
  end

  def tag_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:tags])
  end

	
end
