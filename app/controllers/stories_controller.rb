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

    # Constraint 1.1
    # Only Chief Editors can create stories
    if !current_user.is_chief_editor?

      flash[:danger] = I18n.t 'no-permission-to-create-new-stories'

      redirect_to root_url and return
      
    end 

    headline = params[:headline]
    body = params[:body]
    writer_id = params[:writer_id]
    reviewer_id = params[:reviewer_id]

    valid_writer_id = !writer_id.nil? && !writer_id.eql?('')
    valid_reviewer_id = !reviewer_id.nil? && !reviewer_id.eql?('')

    # Constraint 2
    # A story cannot have the same user as both ​ Writer ​and ​ Reviewer
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

    story.headline = headline

    # Set the creator of the story
    story.creator = current_user
    
    if valid_writer_id
      
      # Parse Integer
      writer_id = writer_id.delete('^0-9')
      writer_id = writer_id.to_i
  
      # Set the writer if writer_id is valid
      begin
      
        writer = User.find(writer_id)
      
      rescue => exception

        flash[:danger] = I18n.t 'writer-not-found'

        redirect_to root_url and return
        
      end

      # Constraint 5
      # Only writers can update the body of a story.

      if valid_writer_id && ( current_user.id == writer_id )

        story.body = body

      elsif !body.nil? && !body.eql?('')

        flash[:warning] = I18n.t 'body-content-was-not-considered'

      end

      story.writer = writer

    end

    # Validates the reviewer_id
    if valid_reviewer_id
  
      reviewer_id = reviewer_id.delete('^0-9')
      reviewer_id = reviewer_id.to_i

      # Set the reviewer if reviewer_id is valid
      begin
      
        reviewer = User.find(reviewer_id)
      
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

      flash[:danger] = I18n.t 'story-not-created'
      
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

    headline = params[:headline]
    body = params[:body]
    writer_id = params[:writer_id]
    reviewer_id = params[:reviewer_id]

    valid_writer_id = !writer_id.nil? && !writer_id.eql?('')
    valid_reviewer_id = !reviewer_id.nil? && !reviewer_id.eql?('')

    story_id = params[:id]
    story_id = story_id.to_i

    # Constraint 2
    # A story cannot have the same user as both ​ Writer ​ and ​ Reviewer
    if valid_writer_id && writer_id == reviewer_id 

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

    # If the current user is a writer, 
    # but is the reviewer
    if current_user.is_writer? && current_user.id == story.reviewer_id

      flash[:danger] = I18n.t 'no-permission-to-change-story'

      redirect_to request.referrer and return

    end

    # If the current user is the writer of the story
    if current_user.id == story.writer_id

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
      story.body = body

    end

    # Constraint 1.2
    # Only the ​ Chief Editor ​can ... assign writers/reviewers
    if current_user.is_chief_editor?

      # If writer_id is valid
      if valid_writer_id
    
        # Parse Integer
        writer_id = writer_id.delete('^0-9')
        writer_id = writer_id.to_i

        # Set the writer if writer_id is valid
        begin
        
          writer = User.find(writer_id)

          story.writer = writer
        
        rescue => exception

          flash[:danger] = I18n.t 'writer-not-found'

          redirect_to request.referrer and return
          
        end

        # Constraint 4
        # A story goes automatically from UNASSIGNED to DRAFT 
        # when the ​ Chief Editor sets the ​ Writer
        if story.status == 'unassigned'

          story.status = 'draft'

        end
        
      end

      # If reviewer_id is valid
      if valid_reviewer_id

        # Parse Integer
        reviewer_id = reviewer_id.delete('^0-9')
        reviewer_id = reviewer_id.to_i

        # Set the reviewer if reviewer_id is valid
        begin
        
          reviewer = User.find(reviewer_id)
          
          story.reviewer = reviewer
        
        rescue => exception

          flash[:danger] = I18n.t 'writer-not-found'

          redirect_to request.referrer and return
          
        end
          
      end

      if current_user.id != story.writer_id
        
        if !body.nil? && !body.eql?('') && !body.eql?(story.body)
          
          flash[:warning] = I18n.t 'body-content-was-not-considered'

        end

      end
    
    end

    # There is no restriction on the update of the headline
    story.headline = headline

    story.save

    flash[:success] = I18n.t 'story-edited'
        
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

    # It makes sense not to allow comments 
    # on approved status onwards
    deny_comment = story.status.eql?('approved')
    deny_comment = story.status.eql?('published') || deny_comment
    deny_comment = story.status.eql?('archived') || deny_comment

    if deny_comment

      flash[:danger] = I18n.t 'cannot-add-comments'

      redirect_to request.referrer and return

    end
    
    # Constraint 9 
    # Only the ​ Chief Editor, and the ​ Writer and ​ Reviewer assigned to the story can
    # post/read comments (when open) on the story page.

    is_writer_assigned = ( current_user.id == story.writer_id )
    is_reviewer_assigned = ( current_user.id == story.reviewer_id ) 
    is_chief_editor = current_user.is_chief_editor?

    can_post_comments = is_writer_assigned
    can_post_comments = is_reviewer_assigned || can_post_comments
    can_post_comments = is_chief_editor || can_post_comments

    if !can_post_comments

      flash[:danger] = I18n.t 'no-permission-to-post-comments'

      redirect_to request.referrer and return

    end 

    # Constraint 10
    # A story is opened to comments only if 
    # no content hasn’t been written yet (fresh story)
    # or if its status is IN REVIEW, 
    # other than that the comments section is blocked.

    is_in_review = story.status.eql?('for_review') || story.status.eql?('in_review')

    is_a_fresh_story = story.body.nil? || story.body.eql?('')

    if !is_a_fresh_story && !is_in_review

      flash[:danger] = I18n.t 'cannot-add-comments'

      redirect_to request.referrer and return

    end

    begin

      story.comments.create(comment: comment,
                            commentator_id: current_user.id )

    rescue => exception
      
      flash[:danger] = I18n.t 'comment-not-added'

      redirect_to request.referrer and return

    end

    flash[:success] = I18n.t 'comment-added'
    
    redirect_to request.referrer and return

  end

end
