class PetsController < ApplicationController
  get "/pets" do
    @pets = Pet.all
    erb :'/pets/index'
  end

  get "/pets/new" do
    @owners = Owner.all
    erb :'/pets/new'
  end

  post "/pets" do
    #exibinding.pry
    pet = Pet.create(name: params["pet"]["name"])
    owner = Owner.find(params["owner"]) if params["owner"]
    if !owner
      owner = Owner.create(name: params["owner_name"])
    end
    pet.owner = owner
    pet.save
    redirect to "pets/#{pet.id}"
  end

  get "/pets/:id" do
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  get "/pets/:id/edit" do
    @pet = Pet.find(params[:id])
    @owners = Owner.all
    erb :'pets/edit'
  end

  patch "/pets/:id" do
    #binding.pry
    @pet = Pet.find(params[:id])
    if !params["owner"]
      @pet.owner = nil
    end

    if params["pet_name"]
      @pet.name = params["pet_name"]
    end

    if params["owner_name"]
      @pet.owner = Owner.find(params["owner_name"].to_i)
    end

    @pet.save

    redirect to "pets/#{@pet.id}"
  end
end
