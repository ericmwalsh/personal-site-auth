class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_filter :verify_signed_out_user, only: :destroy
  before_filter :check_auth_token, only: [:destroy, :authenticate_via_token]

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    data = self.resource.to_json
    render json: data, status: 201
  rescue
    render json: { error: "Incorrect credentials." }, status: 401
  end

  def destroy
    token = request.headers['Auth-Token']
    if user = Admin.find_by_authentication_token(token)
      sign_out user
    else
      render json: { error: "Logout failed; no user found." }, status: 403
    end

    render json: { success: true }, status: 201
  rescue
    render json: { error: "Permission denied." }, status: 403
  end

  def authenticate_via_token
    token = request.headers['Auth-Token']
    if user = Admin.find_by_authentication_token(token)
      render json: { success: true }, status: 201
    else
      return head 403, reason: "Unauthorized authentication - user does not exist."
    end
  end


private

def check_auth_token
  unless request.headers['Auth-Token']
    return head 403, reason: "Unauthorized user access; no included authorization token."
  end
end

end
