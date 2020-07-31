class AuthService < Service

  def auth(params)

    email = params[:email]
    slug = params[:slug]
    password = params[:password]

    args = { email: params[:email], slug: params[:slug] }

    user = User.where(email: email)
               .joins(:organization)
               .merge(Organization.where(slug: slug))
               .first

    if !user.nil?

      organization_slug = user.organization.slug

      if params[:slug] == organization_slug

        if user&.authenticate(params[:password])
          
          return user

        else
          
          raise 'incorrect-password'

        end

      else

        raise 'incorrect-slug'

      end

    else

      raise 'account-not-found'

    end

  end

end