class StoriesService < Service

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

end