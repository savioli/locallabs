class HomeController < ApplicationController
  before_action :authorize

  def index

    pagination_limit = 7

    # My Stories parameter
    my_stories = params[:ms]
    
    # Checks if the my_stories parameter is not null
    if !my_stories.nil?
          
      if !my_stories.eql?('true')

        redirect_to root_url and return

      end

    end


    # Writer (Writer or Reviewer) parameter
    writer_or_reviewer = params[:writer]

    # Checks if the writer_or_reviewer parameter is not null
    if !writer_or_reviewer.nil?
          
      if writer_or_reviewer == ''

        redirect_to root_url and return

      end

    end

    # Status param
    status = params[:status]

    # Checks if the status parameter is not null
    if !status.nil?
          
      if status == ''

        redirect_to root_url and return

      end

    end

    # Pass the parameters to the view
    @my_stories = my_stories

    @status = status

    @writer_or_reviewer = writer_or_reviewer.to_i

    args = {}

    # Mount where of the SQL command
    my_stories_where = ''

    if !my_stories.nil?

      args = args.merge( { current_user_id: current_user.id } )
      my_stories_where = '( writer_id = :current_user_id )'

    end

    writer_or_reviewer_where = ''

    if !writer_or_reviewer.nil? && !writer_or_reviewer.eql?('all')

      args = args.merge( { writer_id: writer_or_reviewer } )
      args = args.merge( { reviewer_id: writer_or_reviewer } )

      writer_or_reviewer_where = '( ( writer_id = :writer_id ) OR ( reviewer_id = :reviewer_id ) )'
      
    end

    status_where = ''

    if !status.nil? && !status.eql?('all')

      if status == 'unassigned'
        status = 0
      elsif status == 'draft'
        status = 1
      elsif status == 'for_review'
        status = 2
      elsif status == 'in_review'
        status = 3
      elsif status == 'pending'
        status = 4
      elsif status == 'approved'
        status = 5
      elsif status == 'published'
        status = 6
      elsif status == 'archived'
        status = 7
      end

      args = args.merge( { status: status } )

      status_where = '( status = :status )'

    end
    
    full_where = ''
    
    if !my_stories_where.eql?('')

      full_where = my_stories_where

    end

    if !writer_or_reviewer_where.eql?('')

      if !my_stories_where.eql?('')

        full_where = full_where + ' AND ' + writer_or_reviewer_where
      
      else

        full_where = writer_or_reviewer_where

      end

    end

    if !status_where.eql?('')

      if !my_stories_where.eql?('') || !writer_or_reviewer_where.eql?('')
      
        full_where = full_where + ' AND ' + status_where
      else

        full_where = status_where

      end

    end

    # Remove from the list all the stories with archived status
    args = args.merge( { archived: 7 } )    

    if status_where.eql?('') 
      
      if full_where.eql?('')

        full_where = ' (status != :archived )'

      else

        full_where = full_where + ' AND (status != :archived )'

      end

    end

    where = Story.where(full_where, args)

    # Gets the stories count
    total_of_stories = where.count
        
    # Get the page parameter
    page = params[:id]

    # Checks if the page parameter is not null
    if !page.nil?

      page = page.to_i

      pagination = Paginator.new(total_of_stories, page, pagination_limit)

      if page <= 0 || page > pagination.max_pages

        flash[:danger] = I18n.t 'page-does-not-exist'

        redirect_to root_url and return

      end

    else

      page = 1

      pagination = Paginator.new(total_of_stories, page, pagination_limit)

    end

    @pagination = pagination

    @stories = where.limit(pagination.limit).offset(pagination.offset)

    # Get all writers
    @writers = User.all
    
    # Keep filtering parameters in the URL
    uri = URI.parse(request.original_url)

    if !uri.query.nil?

      @current_url = '?' + uri.query
    
    else

      @current_url = ''

    end

  end
end
