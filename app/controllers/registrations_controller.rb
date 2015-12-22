class RegistrationsController < Devise::RegistrationsController

# custom Devise override code here

	private

  	def sign_up_params
  		params.require(:user).permit(:email, :name, :company, :company_website, :password)
  	end

  	def account_update_params
  		params.require(:user).permit(:email, :name, :company, :company_website, :password)
  	end

		def update_resource(resource, params)
			resource.update_without_password(params)
		end

end
