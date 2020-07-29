class StoriesService < Service

  # def initialize(first_variable, second_variable)
  #   self.first_variable = first_variable
  #   self.second_variable = second_variable
  # end

  def change_status(user, story, new_status)

    all_status = [ 'unassigned', 
                   'draft', 
                   'for_review', 
                   'in_review', 
                   'pending', 
                   'approved', 
                   'published', 
                   'archived' ]

    status = new_status

    if status.nil? || status.eql?('') || !all_status.include?(status)
      
      raise 'invalid-status'

    end
    
    if story.status == 'unassigned'

      # draft
      if status == 'draft'

        if user.is_writer?

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end
    
    elsif story.status == 'draft'

      if status == 'for_review'
      
        # Constraint 6.1
        if user.id != story.writer_id

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end

    elsif story.status == 'for_review'

      # in_review
      if status == 'in_review'

        # Constraint 7.1
        if user.id != story.reviewer_id

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end

    elsif story.status == 'in_review'

      # pending
      if status == 'pending'

        # Constraint 7.1
        if user.id != story.reviewer_id

          raise 'no-permission-to-change-status'

        end

      # approved
      elsif status == 'approved'

        # Constraint 7.1
        if user.id != story.reviewer_id

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end

    elsif story.status == 'pending'

      raise 'invalid-change-of-status'

    elsif story.status == 'approved'

      # published
      if status == 'published'

        if !user.is_chief_editor?

          raise 'no-permission-to-change-status'

        end

      # archived
      elsif status == 'archived'

        if !user.is_chief_editor?

          raise 'no-permission-to-change-status'

        end

      else

        raise 'invalid-change-of-status'

      end     

    elsif story.status == 'published'

      # archived
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
      
    end

  end
  
  # private
  
  # attr_accessor :first_variable, :second_variable
end