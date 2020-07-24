class HomeController < ApplicationController
  before_action :authorize

  def index

    # My Stories param

    creator = params[:creator]
    
    # Checks whether the creator parameter is not null
    if !creator.nil?
          
      if creator == '' || !creator.eql?('true')

        redirect_to root_url and return

      end

    end

    @creator = creator

    # Writer (Writer or Reviewer) param

    writer_or_reviewer = params[:writer]

    # Checks whether the creator parameter is not null
    if !writer_or_reviewer.nil?
          
      if writer_or_reviewer == ''

        redirect_to root_url and return

      end

    end

    # Status param
    status = params[:status]

    # Checks whether the creator parameter is not null
    if !status.nil?
          
      if status == ''

        redirect_to root_url and return

      end

    end

    @status = status


    # Define a listing limit
    limit = 3

    # Gets the stories count
    total_of_stories = Story.count

    # Calculates the maximum page
    max_pages = total_of_stories / limit

    max_pages = max_pages.ceil

    # Get the page parameter
    page = params[:id]

    # Checks whether the page parameter is not null
    if !page.nil?
      
      page = page.delete('^0-9')

      if page == ''

        redirect_to root_url and return

      else

        page = page.to_i

        if page.is_a? Integer

          redirect_to root_url and return if page <= 0 || (page - 1) > max_pages

        end

      end

    else
      # If the page parameter is null we use 
      # the default page the first page

      page = 1

    end

    # Calculates the offset
    offset = (page - 1) * limit

    # TODO: Comment more
    @page = page
    @offset = offset
    @total_of_stories = Story.count

    delta = 4

    min_page = page - delta

    min_page = 1 if min_page <= 0

    @min_page = min_page

    max_page = page + delta

    max_page = max_pages + 1 if max_page > max_pages

    @max_page = max_page

    @max_pages = max_pages + 1

    @previous_page = page - 1

    @next_page = page + 1

    @next_page = @max_pages if @next_page > @max_pages

    @previous_page = 1 if @previous_page <= 0

    @stories = Story.limit(limit).offset(offset)

    # Get all writers
    @writers = Writer.all
    
    is_the_first_param = true

    current_url = ''

    if !creator.nil? 

      if is_the_first_param

        current_url.concat( '?' )

        is_the_first_param = false

      else
      
        current_url.concat( '&' )

      end

      current_url.concat( 'creator=' )
      current_url.concat( creator.to_s )

    end

    # Writer param

    if !writer_or_reviewer.nil? 

      if is_the_first_param

        current_url.concat( '?' )

        is_the_first_param = false
      
      else
      
        current_url.concat( '&' )

      end

      current_url.concat( 'writer=' )
      current_url.concat( writer_or_reviewer )

    end

    # Status param
    if !status.nil? 

      if status

        current_url.concat( '?' )

        is_the_first_param = false
      
      else
      
        current_url.concat( '&' )

      end

      current_url.concat( 'status=' )
      current_url.concat( status )

    end

    @current_url = current_url

  end
end
