class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_filter :verify_signed_out_user, only: :destroy

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    data = self.resource.to_json
    render json: data, status: 201
  rescue
    render json: { error: "Incorrect credentials." }, status: 401
  end

  def destroy
    unless token = request.headers['Auth-Token']
      return head 403, reason: "Unauthorized user logout; no included authorization token."
    end
    if user = Admin.find_by_authentication_token(token)
      sign_out user
    else
      render json: { error: "Logout failed; no user found." }, status: 403
    end

    # signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    render json: { success: true }, status: 201
  rescue
    render json: { error: "Permission denied." }, status: 403
  end


  private

end
