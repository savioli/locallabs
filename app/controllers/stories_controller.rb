class StoriesController < ApplicationController
  before_action :authorize

  def view

    # Get the page parameter
    page = params[:id]

    # Checks whether the page parameter is not null
    if !page.nil?
      
      page = page.delete('^0-9')

      if page == ''

        redirect_to root_url and return

      else

        page = page.to_i

      end

    else
      # If the page parameter is null we use 
      # the default page the first page

      redirect_to root_url and return

    end

    @story = Story.find(page)

  end

  def edit
    # Get the page parameter
    page = params[:id]

    # Checks whether the page parameter is not null
    if !page.nil?
      
      page = page.delete('^0-9')

      if page == ''

        redirect_to root_url and return

      else

        page = page.to_i

      end

    else
      # If the page parameter is null we use 
      # the default page the first page

      redirect_to root_url and return

    end

    @story = Story.find(page)

    writer_id = @story.writer_id

    if !writer_id.nil?

      @writer = Writer.find(writer_id)

    else

      @writer = nil
    
    end

    reviewer_id = @story.reviewer_id

    if !reviewer_id.nil?

      @reviewer = Writer.find(reviewer_id)

    else

      @reviewer = nil

    end

    # Get all writers
    @writers = Writer.all   

  end
end
