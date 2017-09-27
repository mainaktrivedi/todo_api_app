require 'rails_helper'

RSpec.describe TagsController, type: :controller do

	before do
	  Rails.application.load_seed
	end

    let :updated_tag_title do
    	"Updated Tag Title"
    end
    
    let :new_record do
       Tag.create!(title: "something")
    end

    context "#GET Index" do

      let :path do
        get :index
      end

      before do
        path
      end

      it "responds with a successful status code" do
        expect(response).to be_success
      end

      it "returns JSON" do
        expect(response.content_type).to eq('application/json')
      end

      it "responds with a 200 status code" do
        expect(response.status).to eq(200)
      end

      it "responds with correct title" do
      	data = JSON.parse(response.body)
        expect(data[0]["title"]).to eq("Today")
      end
    end

    context "#POST Create" do

      let :post_params do
        {
		 "data" =>
			{	"type" => "undefined",
				"id" => "undefined",
				"attributes" => {
					"title" => "Someday"
				}
			}
        }
      end

      let :path do
        post :create, params: post_params
      end

	    context "with valid params" do

	      before do
	        path
	      end

	      it "responds with a successful status" do
	        expect(response).to be_success
	      end

	      it "returns JSON" do
	        expect(response.content_type).to eq('application/json')
	      end

	      it "responds with a 201 status code" do
	        expect(response.status).to eq(201)
	      end

	      it "returns valid data" do
	      	data = JSON.parse(response.body)
	        expect(data["title"]).to eq("Someday")
	        expect(data["id"]).to be > 0
	      end

          it "persists data" do
          	data = JSON.parse(response.body)
	       	tag = Tag.find(data["id"])
	      	expect(tag).to be_truthy
	      	expect(tag.id).to be > 1
      	  end
	    end

	    context "with invalid params" do

	      before do
	        post_params.merge!({data: { type: "undefined", id: "undefined", attributes: {title: ""} } })
	        path
	      end

	      it "returns JSON" do
	        expect(response.content_type).to eq('application/json')
	      end

	      it "responds with a 422 status code" do
	        expect(response.status).to eq(422)
	      end

	      it "returns an array of errors" do
	        expect(JSON.parse(response.body)["errors"]).to be_present
	      end

	    end
    end

    context "#PATCH Update" do


      let :patch_params do
        {
         "id" => new_record.id,	
		 "data" =>
			{	"type" => "tags",
				"id" => "2",
				"attributes" => {
					"title" => updated_tag_title
				}
			}
        }
      end

      let :path_update do
        patch :update, params: patch_params
      end

      before do
	    path_update
	  end

	    context "with valid params" do


	      it "responds with a successful status" do
	        expect(response).to be_success
	      end

	      it "returns JSON" do
	        expect(response.content_type).to eq('application/json')
	      end

	      it "responds with a 200 status code" do
	        expect(response.status).to eq(200)
	      end

	      it "returns valid data" do
	      	data = JSON.parse(response.body)
	        expect(data["title"]).to eq(updated_tag_title)
	        expect(data["id"]).to eq(2)
	      end

	      it "persists data" do
	      	expect(new_record.reload.title).to eq(updated_tag_title)
	      end
	    end

    end
end
