require 'rails_helper'

RSpec.describe TasksController, type: :controller do

	before do
	  Rails.application.load_seed
	end

    let :updated_task_title do
    	"Updated Task Title"
    end

    let :new_record do
       Task.create!(title: "something")
    end

    context "#GET Index" do

      let :path do
        get :index
      end

      context "no tags" do
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
	        expect(data[0]["title"]).to eq("Wash laundry")
	      end
      end


      context "with tags" do

		  let :new_record do
		  	t1 = Tag.create!(title: "Home")
		  	t2 = Tag.create!(title: "Work")
		  	Task.create!(title: updated_task_title, tag_ids: [t1.id,t2.id])
		  end

	      before do
	      	new_record
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

	      it "responds with correct title and tags" do
	      	data = JSON.parse(response.body)
	        expect(data[1]["title"]).to eq(updated_task_title)
	        expect(data[1]["tags"][0]["id"]).to be > 1
	      end

	      it "persists data" do
	      	expect(new_record.reload.tags.count).to be > 0
	      	expect(new_record.reload.tags[0].id).to be > 1
	      	expect(new_record.reload.tags[1].id).to be > 1
	      end
	  end
    end

    context "#POST Create" do

      let :post_params do
        {
		 "data" =>
			{	"type" => "undefined",
				"id" => "undefined",
				"attributes" => {
					"title" => "Do Homework"
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
	        expect(data["title"]).to eq("Do Homework")
	        expect(data["id"]).to be > 0
	      end

          it "persists data" do
          	data = JSON.parse(response.body)
	       	task = Task.find(data["id"])
	      	expect(task).to be_truthy
	      	expect(task.id).to be > 1
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
			{	"type" => "tasks",
				"id" => "2",
				"attributes" => {
					"title" => updated_task_title
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

	    context "with valid params NO tag" do

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
	        expect(data["title"]).to eq(updated_task_title)
	        expect(data["id"]).to eq(new_record.id)
	      end

	      it "persists data" do
	      	expect(new_record.reload.title).to eq(updated_task_title)
	      end

	    end

	    context "with valid params and tag" do

		  let :patch_params do
	        {
	         "id" => new_record.id,	
			 "data" =>
				{	"type" => "tasks",
					"id" => new_record.id,
					"attributes" => {
						"title" => updated_task_title,
						"tags" => [ "Urgent", "Home"]
					}
				}
	        }
	      end

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
	        expect(data["title"]).to eq(updated_task_title)
	        expect(data["id"]).to eq(new_record.id)

	        expect(data["tags"][0]["id"]).to be > 1
	        expect(data["tags"][1]["id"]).to be > 1
	      end

	      it "persists data" do
	      	expect(new_record.reload.title).to eq(updated_task_title)
	        expect(new_record.reload.tags.count).to eq(2)
	      end

	    end

	    
    end

    context "#DELETE Delete" do


       let :delete_params do
        {
         "id" => 2
        }
      end

      let :path_destroy do
        delete :destroy, params: delete_params
      end

	    before do
	      new_record
	      path_destroy
	    end

	    context "with valid params" do

	      it "responds with a successful status" do
	        expect(response).to be_success
	      end

	      it "returns JSON" do
	        expect(response.content_type).to eq(nil)
	      end

	      it "responds with a 204 status code" do
	        expect(response.status).to eq(204)
	      end

	      it "deletes data" do
	      	expect(Task.exists?(id: new_record.id)).to be_falsy
      	  end

	    end
    end
end






