class StoriesController < ApplicationController
  before_action :authorize

  def new

    # Constraint 1.1
    if current_user.is_writer?
      
      flash[:danger] = I18n.t 'no-permission-to-create-new-stories'

      redirect_to root_url and return

    end 

    # Get all writers
    @writers = User.all

  end

  def create

    stories_service = StoriesService.new

    begin

      stories_service.create_story(current_user, params)

      body = params[:body]

      if current_user.id != story.writer_id
        
        if !body.nil? && !body.eql?('')
          
          flash[:warning] = I18n.t 'body-content-was-not-considered'

        end

      end

      flash[:success] = I18n.t 'story-created'

    rescue => exception
      
      flash[:danger] = I18n.t exception.message

    end

    redirect_to root_url and return

  end

  def edit

    # Get the page parameter
    story_id = params[:id]
    
    story_id = story_id.to_i

    begin

      @story = Story.find(story_id)

    rescue => exception

      flash[:danger] = I18n.t 'story-not-found'

      redirect_to root_url and return

    end

    writer = @story.writer

    if !writer.nil?

      @writer = @story.writer

    else

      @writer = Writer.new
      @writer.name = I18n.t 'not-assigned-yet'
    
    end

    reviewer = @story.reviewer

    if !reviewer.nil?

      @reviewer = @story.reviewer

    else

      @reviewer = Writer.new
      @reviewer.name = I18n.t 'not-assigned-yet'

    end

    if current_user.is_writer?
      
      # Constraint 12.1
      # Only the ​ Chief Editor, and the ​ Writer and ​ Reviewer assigned to the story can see the
      # content of a story before it’s been published

      # So, if not the writer assigned to the story or
      # not the reviewer assigned to the story
      if ( current_user.id.to_i != @story.writer_id.to_i ) && ( current_user.id != @story.reviewer_id ) 

        flash[:danger] = I18n.t 'no-permission-to-access-story'

        redirect_to root_url and return
      
      end

    end

    # Get all writers
    @writers = User.all   

  end

  def update

    story_id = params[:id]
    story_id = story_id.to_i

    begin

      story = Story.find(story_id)

    rescue => exception

      flash[:danger] = I18n.t 'story-not-found'

      redirect_to root_url and return

    end

    stories_service = StoriesService.new

    begin

      stories_service.update_story(current_user, story, params)

      flash[:success] = I18n.t 'story-edited'

      if current_user.id != story.writer_id
        
        body = params[:body]
        
        if !body.nil? && !body.eql?(story.body)
          
          flash[:warning] = I18n.t 'body-content-was-not-considered'

        end

      end

    rescue => exception
      
      flash[:danger] = I18n.t exception.message

    end
        
    redirect_to request.referrer and return

  end

  def status
    
    story_id = params[:id]
      
    begin

      story = Story.find(story_id)

    rescue => exception

      flash[:danger] = I18n.t 'story-not-found'

      redirect_to root_url and return
            
    end

    stories_service = StoriesService.new

    new_status = params[:status]

    begin

      stories_service.change_story_status(current_user, story, new_status)

    rescue => exception
      
      flash[:danger] = I18n.t exception.message

      redirect_to request.referrer and return

    end

    redirect_to request.referrer and return

  end

  def comment 

    story_id = params[:id]
    comment = params[:comment]

    # Ignore empty comments
    if comment.nil? || comment.eql?('')

      flash[:warning] = I18n.t 'empty-comment-not-considered'

      redirect_to request.referrer and return

    end

    begin

      story = Story.find(story_id)

    rescue => exception

      flash[:danger] = I18n.t 'story-not-found'

      redirect_to root_url and return
            
    end
    
    begin
      
      comment = params[:comment]

      stories_service = StoriesService.new

      stories_service.add_comment_to_story(current_user, story, comment)
      
      flash[:success] = I18n.t 'comment-added'

    rescue => exception
      
      flash[:danger] = I18n.t exception.message

    end

    redirect_to request.referrer and return

  end


end
