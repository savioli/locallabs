class StoriesService < Service

  def create_story(user, params)

    # Constraint 1.1
    # Only Chief Editors can create stories
    if !user.is_chief_editor?

      raise 'no-permission-to-create-new-stories'
      
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

      raise 'writer-and-reviewer-connot-be-the-same'
    
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
    story.creator = user
    
    if valid_writer_id
      
      # Parse Integer
      writer_id = writer_id.delete('^0-9')
      writer_id = writer_id.to_i
  
      # Set the writer if writer_id is valid
      begin
      
        writer = User.find(writer_id)
      
      rescue => exception

        raise 'writer-not-found'
        
      end

      # Constraint 5
      # Only writers can update the body of a story.

      if valid_writer_id && ( user.id == writer_id )

        story.body = body

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

        raise 'reviewer-not-found'
        
      end

      story.reviewer = reviewer

    end

    begin

      story.save  

    rescue => exception

      raise 'story-not-created'
      
    end

  end

  def update_story(user, story, params)

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

      raise 'writer-and-reviewer-connot-be-the-same'

    end

    # If a story has been approved, published,
    # or archived, it cannot be changed
    deny_update = (story.status == 'approved')
    deny_update = (story.status == 'published') || deny_update
    deny_update = (story.status == 'archived') || deny_update

    if deny_update

      raise 'no-permission-to-change-story'

    end

    # If the current user is a writer, 
    # but is the reviewer
    if user.is_writer? && user.id == story.reviewer_id

      raise 'no-permission-to-change-story'

    end

    # If the current user is the writer of the story
    if user.id == story.writer_id

      deny_update = (story.status == 'for_review')
      deny_update = (story.status == 'in_review') || deny_update

      if deny_update
  
        raise 'no-permission-to-change-story-in-review'
    
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
    if user.is_chief_editor?

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

          raise 'writer-not-found'

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

          raise 'reviewer-not-found'

        end
          
      end
          
    end

    # There is no restriction on the update of the headline
    story.headline = headline

    begin
      
      story.save

    rescue => exception

      raise 'story-not-updated'
      
    end

  end

  def change_story_status(user, story, new_status)

    all_status = [ 'unassigned', 
                   'draft', 
                   'for_review', 
                   'in_review', 
                   'pending', 
                   'approved', 
                   'published', 
                   'archived' ]

    status = new_status

    if !all_status.include?(status)
      
      raise 'invalid-status'

    end
    
    if story.status == 'unassigned'

      if status == 'draft'

        if user.is_writer?

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end
    
    elsif story.status == 'draft'

      if status == 'for_review'
      
        # Constraint 6
        # A ​writer ​can only set the status to FOR REVIEW
        if user.id != story.writer_id

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end

    elsif story.status == 'for_review'

      # Constraint 7
      # A ​ Reviewer can only set the status to 
      # IN REVIEW (start review), 
      # PENDING (request changes) and 
      # APPROVED (approve story);
      if status == 'in_review'

        if user.id != story.reviewer_id

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end

    elsif story.status == 'in_review'

      # Constraint 7
      # A ​ Reviewer can only set the status to 
      # IN REVIEW (start review), 
      # PENDING (request changes) and 
      # APPROVED (approve story);        

      if status == 'pending'

        if user.id != story.reviewer_id

          raise 'no-permission-to-change-status'

        end

      elsif status == 'approved'

        if user.id != story.reviewer_id

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end

    elsif story.status == 'pending'

      raise 'invalid-change-of-status'

    elsif story.status == 'approved'

      if status == 'published'

        if !user.is_chief_editor?

          raise 'no-permission-to-change-status'

        end

      elsif status == 'archived'

        if !user.is_chief_editor?

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end     

    elsif story.status == 'published'

      if status == 'archived'

        if !user.is_chief_editor?

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end

    elsif story.status == 'archived'

      raise 'invalid-change-of-status'

    end

    begin
      
      story.status = status
      story.save
  
    rescue => exception
      
      raise 'error-while-changing-status'

    end

  end

  def add_comment_to_story(user, story, comment)

    # It makes sense not to allow comments 
    # on approved status onwards
    deny_comment = story.status.eql?('approved')
    deny_comment = story.status.eql?('published') || deny_comment
    deny_comment = story.status.eql?('archived') || deny_comment

    if deny_comment

      raise 'cannot-add-comments'

    end
    
    # Constraint 9 
    # Only the ​ Chief Editor, and the ​ Writer and ​ Reviewer assigned to the story can
    # post/read comments (when open) on the story page.

    is_writer_assigned = (user.id == story.writer_id)
    is_reviewer_assigned = (user.id == story.reviewer_id) 
    is_chief_editor = user.is_chief_editor?

    can_post_comments = is_writer_assigned
    can_post_comments = is_reviewer_assigned || can_post_comments
    can_post_comments = is_chief_editor || can_post_comments

    if !can_post_comments

      raise 'no-permission-to-post-comments'

    end 

    # Constraint 10
    # A story is opened to comments only if 
    # no content hasn’t been written yet (fresh story)
    # or if its status is IN REVIEW, 
    # other than that the comments section is blocked.

    is_in_review = story.status.eql?('for_review') || story.status.eql?('in_review')

    is_a_fresh_story = story.body.nil? || story.body.eql?('')

    if !is_a_fresh_story && !is_in_review

      raise 'cannot-add-comments'

    end

    begin

      story.comments.create(comment: comment,
                            commentator_id: user.id )

    rescue => exception
      
      raise 'comment-not-added'

    end

  end

end