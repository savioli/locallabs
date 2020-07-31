class SessionsController < ApplicationController
  def new

    if current_user

      redirect_to root_url

    end
    
  end

  def create

    # Simple Validation
    email = params[:email].strip
    slug = params[:slug].strip
    password = params[:password].strip

    valid_fields = true

    if slug.length < 3

      flash[:slug] = I18n.t 'invalid-slug-length'

      valid_fields = false

    end

    if password.length < 1

      flash[:password] = I18n.t 'invalid-password-length'

      valid_fields = false

    end
    
    email_validate = /(\A([a-z]*\s*)*\<*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\>*\Z)/i

    if !email_validate.match(email)
      
      flash[:email] = I18n.t 'invalid-email'

      valid_fields = false

    end

    if !valid_fields

      redirect_to login_path and return

    end

    auth_service = AuthService.new

    begin
      
      user = auth_service.auth(params)

      session[:user_id] = user.id
      session[:organization_id] = user.organization_id

      redirect_to root_url

    rescue => exception

      flash[:danger] = I18n.t exception.message

      redirect_to login_path
      
    end

  end

  def destroy
    
    session[:user_id] = nil
    session[:organization_id] = nil

    flash[:danger] = I18n.t 'logout'
    
    redirect_to login_path

  end

end
