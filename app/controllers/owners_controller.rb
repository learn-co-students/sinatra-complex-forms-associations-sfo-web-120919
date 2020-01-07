require 'pry'
class OwnersController < ApplicationController

  get '/owners' do
    @owners = Owner.all
    erb :'/owners/index' 
  end

  get '/owners/new' do
    @pets = Pet.where(owner: nil) 
    erb :'/owners/new'
  end

  post '/owners' do
    # associate checked pets with owner
    #binding.pry
    owner = Owner.create(name: params["owner"]["name"])
    pets = params["owner"]["pet_ids"] and params["owner"]["pet_ids"].map do |id|
      pet = Pet.find(id.to_i)
      pet.owner = owner
      owner.pets << pet 
    end

    # make new pet, associate with owner
    if params["pet"]["name"]
      pet = Pet.create(name: params["pet"]["name"])
      pet.owner = owner
      owner.pets << pet
    end 
    
    redirect "owners/#{owner.id}"
    
  end

  get '/owners/:id/edit' do 
    @owner = Owner.find(params[:id])
    erb :'/owners/edit'
  end

  get '/owners/:id' do 
    @owner = Owner.find(params[:id])
    erb :'/owners/show'
  end

  patch '/owners/:id' do
    #binding.pry
    owner = Owner.find(params[:id])
    # set new name
    if params["owner"]["name"]
      owner.name = params["owner"]["name"]
      owner.save
    end   
    # remove old pet associations
    #binding.pry
    
    owner.pets.each do |pet|
      pet.owner = nil
      pet.save
    end 
    
    # build new pet associations, based on user input

    params["edited_existing_pets"].values().each do |pet_id|
      pet = Pet.find(pet_id.to_i)
      if pet
        pet.owner = owner
        pet.save
      end 

    end 

    new_pet = Pet.create(name: params["pet"]["name"])
    new_pet.owner = owner
    new_pet.save 
  
    redirect "/owners/#{owner.id}" 
   
  end
end