class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :apple

  def apple
    data = request.env['omniauth.auth']['info']
    @user = User.where(email: data['email']).first
    @user ||= User.create(
      email: data['email'],
      password: Devise.friendly_token[0, 20]
    )

    if @user.persisted?
      flash[:notice] = 'Welcome!'
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:alert] = I18n.t 'Authentication failed, please try again.'
      redirect_to new_user_registration_url, notice: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: 'Authentication failed, please try again.'
  end
end