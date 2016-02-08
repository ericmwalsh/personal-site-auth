class ApplicationController < ActionController::API
  # before_filter :authenticate_user_from_token!
  # before_filter :authenticate_user!
  before_filter :check_device_kind

  # protected

  # def authenticate_user_from_token!
  #   user_email = params[:user_email].presence
  #   user       = user_email && User.find_by_email(user_email)

  #   # Notice how we use Devise.secure_compare to compare the token
  #   # in the database with the token given in the params, mitigating
  #   # timing attacks.
  #   if user && Devise.secure_compare(user.authentication_token, params[:user_token])
  #     sign_in user, store: false
  #   end
  # end

  protected

  def check_device_kind
    unless token = request.headers['Device-Kind']
      return head 401, reason: "Unauthorized user; missing required params."
    end
  end

  def authenticate_user_from_token!
    authenticated = authenticate_with_http_token do |user_token, options|
      user_email = options[:user_email].presence
      user       = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, user_token)
        sign_in user, store: false
      else
        render json: 'Invalid authorization.'
      end
    end

    if !authenticated
      render json: 'No authorization provided.'
    end
  end
end
