class StoriesController < ApplicationController
  before_action :authorize

  def new

    # Constraint 1.1
    if current_user.is_writer?
      
      flash[:danger] = I18n.t 'no-permission-to-create-new-stories'

      redirect_to root_url and return

    end 

    # Get all writers
    @writers = Writer.all

  end

  def create

    # Constraint 1.1
    # Only Chief Editors can create stories    
    if current_user.is_writer?

      flash[:danger] = I18n.t 'no-permission-to-create-new-stories'

      redirect_to root_url
      
    end 

    headline = params[:headline]
    writer_id = params[:writer_id]
    reviewer_id = params[:reviewer_id]

    valid_writer_id = !writer_id.nil? && !writer_id.eql?('')
    valid_reviewer_id = !reviewer_id.nil? && !reviewer_id.eql?('')

    # Constraint 2
    # A story cannot have the same user as both ​ Writer ​ and ​ Reviewer; ​
    if valid_writer_id && ( writer_id == reviewer_id )

      flash[:danger] = I18n.t 'writer-and-reviewer-connot-be-the-same'

      redirect_to request.referrer and return
    
    end

    story = Story.new

    story.status = 'unassigned'

    # Constraint 4
    # A story goes automatically from UNASSIGNED to DRAFT 
    # when the Chief Editor sets the ​Writer ​
    if valid_writer_id
      
      story.status = 'draft'
      
    end

    # Does not creates with body because of:
    # Constraint 5
    # Only writers can update the body of a story.

    story.headline = headline

    # Set the creator of the story
    story.creator = current_user
    
    # Validates the writer_id
    if valid_writer_id
  
      writer_id = writer_id.delete('^0-9')
      writer_id = writer_id.to_i

    end

    # Set the writer if writer_id is valid
    if valid_writer_id

      begin
      
        writer = Writer.find(writer_id)
      
      rescue => exception

        flash[:danger] = I18n.t 'writer-not-found'

        redirect_to root_url and return
        
      end

      story.writer = writer

    end

    # Validates the reviewer_id
    if valid_reviewer_id
  
      reviewer_id = reviewer_id.delete('^0-9')
      reviewer_id = reviewer_id.to_i

    end

    # Set the reviewer if reviewer_id is valid
    if valid_reviewer_id

      begin
      
        reviewer = Writer.find(reviewer_id)
      
      rescue => exception

        flash[:danger] = I18n.t 'writer-not-found'

        redirect_to root_url and return
        
      end

      story.reviewer = reviewer

    end

    begin

      story.save  

      flash[:success] = I18n.t 'story-created'

    rescue => exception

      flash[:success] = I18n.t 'story-not-created'
      
    end

    redirect_to root_url

  end

  def edit

    # Get the page parameter
    story_id = params[:id]
    
    story_id = story_id.to_i

    begin

      @story = Story.find(story_id)

    rescue => exception

      flash[:danger] = I18n.t 'story-not-found'

      redirect_to request.referrer and return

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
    @writers = Writer.all   

  end

  def update

    headline = params[:headline]
    body = params[:body]

    writer_id = params[:writer_id]
    reviewer_id = params[:reviewer_id]

    story_id = params[:id]
    story_id = story_id.to_i

    valid_writer_id = !writer_id.nil? && !writer_id.eql?('')
    valid_reviewer_id = !reviewer_id.nil? && !reviewer_id.eql?('')

    # Constraint 2
    # A story cannot have the same user as both ​ Writer ​ and ​ Reviewer
    if ( valid_writer_id ) && writer_id == reviewer_id 

      flash[:danger] = I18n.t 'writer-and-reviewer-connot-be-the-same'

      redirect_to request.referrer and return

    end

    begin

      story = Story.find(story_id)

    rescue => exception

      flash[:danger] = I18n.t 'story-not-found'

      redirect_to root_url and return

    end

    # If a story has been approved, published,
    # or archived, it cannot be changed
    deny_update = (story.status == 'approved')
    deny_update = (story.status == 'published') || deny_update
    deny_update = (story.status == 'archived') || deny_update

    if deny_update

      flash[:danger] = I18n.t 'no-permission-to-change-story'

      redirect_to request.referrer and return

    end

    # Constraint 1.2
    if current_user.is_writer?

      deny_update = ( story.status == 'for_review' ) || ( story.status == 'in_review' )

      if deny_update
  
        flash[:danger] = I18n.t 'no-permission-to-change-story-in-review'
  
        redirect_to request.referrer and return
  
      end  
      
      # Constraint 8
      # If a story has a PENDING status, it goes automatically 
      # from PENDING to DRAFT if the ​ writer ​ updates the body (content).
      if story.status == 'pending'
      
        if !body.eql?(story.body)
          
          # If the body has changed, 
          # the status go from PENDING to DRAFT
          story.status = 'draft'
          
        end

      end

      # Constraint 5
      # Only writers can update the body of a story.
      writer_assigned_to_the_story = !story.writer_id.nil? && ( story.writer_id == current_user.id )

      if writer_assigned_to_the_story

        story.headline = headline
        story.body = body

      else

        flash[:danger] = I18n.t 'no-permission-to-change-body'

        redirect_to request.referrer and return

      end
      
      story.save

    elsif current_user.is_chief_editor?

      # Constraint 4
      # A story goes automatically from UNASSIGNED to DRAFT 
      # when the ​ Chief Editor sets the ​ Writer
      if story.status == 'unassigned'

        if valid_writer_id

          story.status = 'draft'

        end

      end

      # Does not update the body because of: 
      # Constraint 5
      # Only writers can update the body of a story.

      story.headline = headline

      if valid_writer_id
    
        writer_id = writer_id.delete('^0-9')
        writer_id = writer_id.to_i

      end

      # Set the writer if writer_id is valid
      if valid_writer_id

        begin
        
          writer = Writer.find(writer_id)
        
        rescue => exception

          flash[:danger] = I18n.t 'writer-not-found'

          redirect_to request.referrer and return
          
        end

        story.writer = writer
        
      end

      # Validates the reviewer_id
      if valid_reviewer_id
    
        reviewer_id = reviewer_id.delete('^0-9')
        reviewer_id = reviewer_id.to_i

      end

      # Set the reviewer if reviewer_id is valid
      if valid_reviewer_id

        begin
        
          reviewer = Writer.find(reviewer_id)
        
        rescue => exception

          flash[:danger] = I18n.t 'writer-not-found'

          redirect_to request.referrer and return
          
        end

        story.reviewer = reviewer
          
      end

        flash[:success] = I18n.t 'story-edited'
        
        story.save
    
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

      stories_service.change_status(current_user, story, new_status)

    rescue => exception
      
      flash[:danger] = I18n.t exception.message

      redirect_to request.referrer and return

    end

    redirect_to request.referrer and return

  end


end
