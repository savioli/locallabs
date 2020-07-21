class SessionsController < ApplicationController
  def new

    if current_user

      redirect_to root_url, notice: 'Logged In!'

    end
    
  end

  def create

    user = User.where(email: params[:email]).first

    if user

      organization_slug = user.organization.slug

      if params[:slug] == organization_slug

        if user&.authenticate(params[:password])

          session[:user_id] = user.id

          redirect_to root_url, notice: 'Logged In!'

        else

          # flash.now[:alert] = "E-mail or password is invalid!EP"
          # render "new"
          redirect_to login_path, notice: 'E-mail or password is invalid!EP'

        end

      else

        # flash.now[:alert] = "E-mail or password is invalid!SLUG"
        # render "new"
        redirect_to login_path, notice: 'E-mail or password is invalid!SLUG'

      end

    else

      redirect_to login_path, notice: 'E-mail or password is invalid!SLUG'

    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logged out!'
  end
end
