class TagsController < ApplicationController
	# GET /tags
	# GET /tags.json
	def index
    @tags = Tag.all
    render json: @tags, status: 200
  end
	# GET /tags/1
	# GET /tags/1.json
  def show
    render json: tag, status: 200
  end

	# POST /tags
	# POST /tags.json
	def create
	  @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag, status: :created
    else
      render json: {errors: @tag.errors}, status: :unprocessable_entity
    end
	end
  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    if tag.update(tag_params)
      render json: tag, status: :ok
    else
      render json: {errors: tag.errors}, status: :unprocessable_entity
    end
  end
  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    tag.destroy
    render json: {}, status: :no_content
  end

  private
  def tag
    @tag ||= Tag.find(params[:id])
  end

  def tag_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:title])
  end


end
