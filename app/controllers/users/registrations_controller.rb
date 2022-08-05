module Users
  class RegistrationsController < Devise::RegistrationsController
    include Devise::DeviseDoorkeeperable

    def create
      self.resource = User.new(sign_up_params)
      if self.resource.save
        if resource.active_for_authentication?
          render_access_token_from_resource
        else
          render status: :created
        end
      else
        render json: resource.errors.full_messages, status: :unprocessable_entity
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(:email, :password)
    end
  end
end
