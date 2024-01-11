# Purpose: Pets Controller that handles requests according to:
# https://github.com/OAI/OpenAPI-Specification/blob/main/examples/v3.0/petstore.yaml
class PetsController < ApplicationController
  before_action :set_pet, only: %i[ show update destroy ]

  # GET /pets
  def index
    @pets = Pet.all
    # Just hardcoding the next link for now to fullfill the spec
    response.set_header("X-Next", "http://localhost:3000/pets?next")
    render json: @pets
  end

  # GET /pets/1
  def show
    render json: @pet
  end

  # POST /pets
  def create
    @pet = Pet.new(pet_params)

    if @pet.save
      render json: @pet, status: :created, location: @pet
    else
      error = ApiError.new(422, @pet.errors.full_messages.join(", "))
      render json: { error: error }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pets/1
  def update
    if @pet.update(pet_params)
      render json: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pets/1
  def destroy
    @pet.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error = ApiError.new(404, "Pet not found")
      render json: { error: error }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def pet_params
      params.require(:pet).permit(:name)
    end
end
