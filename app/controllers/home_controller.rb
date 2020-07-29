class HomeController < ApplicationController
  before_action :authorize

  def index

    # My Stories param

    my_stories = params[:ms]
    
    # Checks whether the my_stories parameter is not null
    if !my_stories.nil?
          
      if !my_stories.eql?('true')

        redirect_to root_url and return

      end

    end

    @my_stories = my_stories

    # Writer (Writer or Reviewer) param

    writer_or_reviewer = params[:writer]

    # Checks whether the my_stories parameter is not null
    if !writer_or_reviewer.nil?
          
      if writer_or_reviewer == ''

        # redirect_to root_url and return

      end

    end

    # Status param
    status = params[:status]

    # Checks whether the my_stories parameter is not null
    if !status.nil?
          
      if status == ''

        redirect_to root_url and return

      end

    end

    @status = status
    @writer_or_reviewer = writer_or_reviewer.to_i

    args = { }

    if !my_stories.nil?

      if current_user.is_chief_editor?
        args = args.merge( { :creator_id => current_user.id } )
      else
        args = args.merge( { :writer_id => current_user.id } )
      end

    end

    if !writer_or_reviewer.nil? && !writer_or_reviewer.eql?('all')
      args = args.merge( { :writer_id => writer_or_reviewer } )
    end

    if !status.nil?
      args = args.merge( { :status => status } )
    end

    # Gets the stories count
    if args.length == 0
      total_of_stories = Story.count
    else
      total_of_stories = Story.where( args ).count
    end
    
    # Get the page parameter
    page = params[:id]

    # Checks whether the page parameter is not null
    if !page.nil?

      page = page.to_i

      pagination = Paginator.new(total_of_stories, page)

      # pagination.max_pages <= 0
      if page <= 0 || page > pagination.max_pages

        flash[:danger] = I18n.t 'page-does-not-exist'

        redirect_to root_url and return

      end

    else

      page = 1

      pagination = Paginator.new(total_of_stories, page)

    end

    @pagination = pagination


    if args.length == 0
      @stories = Story.limit(pagination.limit).order(id: :desc).offset(pagination.offset)
    else
      @stories = Story.where( args ).limit(pagination.limit).offset(pagination.offset)
    end

    # Get all writers
    @writers = Writer.all
    
    uri = URI.parse(request.original_url)

    if !uri.query.nil?

      @current_url = '?' + uri.query
    
    else

      @current_url = ''

    end

  end
end
