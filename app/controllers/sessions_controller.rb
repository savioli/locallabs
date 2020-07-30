class SessionsController < ApplicationController
  def new

    if current_user

      redirect_to root_url

    end
    
  end

  def create

    # TODO: Better validation

    email = params[:email]

    slug = params[:slug]

    password = params[:password]

    if ( slug.length < 3 ) || ( password.length < 1 )

      flash[:danger] = I18n.t 'invalid-fields'

      redirect_to login_path and return
    
    end

    user = User.where(email: params[:email]).first

    if !user.nil?

      organization_slug = user.organization.slug

      if params[:slug] == organization_slug

        if user&.authenticate(params[:password])

          session[:user_id] = user.id

          redirect_to root_url

        else

          flash[:danger] = I18n.t 'incorrect-password'

          redirect_to login_path

        end

      else

        flash[:danger] = I18n.t 'incorrect-slug'

        redirect_to login_path

      end

    else

      flash[:danger] = I18n.t 'account-not-found'

      redirect_to login_path

    end
  end

  def destroy
    
    session[:user_id] = nil

    flash[:danger] = I18n.t 'logout'
    
    redirect_to login_path

  end

end
