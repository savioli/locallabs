class StoriesController < ApplicationController
  before_action :authorize

  def new

    # Constraint 1.1

    if current_user.is_writer?
      
      flash[:danger] = "You don't have permission to create new stories."

      redirect_to root_url and return

    end 

    # Get all writers
    @writers = Writer.all

  end

  def create

    # Constraint 1.1
    
    if current_user.is_writer?

      flash[:danger] = "You don't have permission to create new stories."

      redirect_to root_url
      
    end 

    # TODO: add validation with feedback

    headline = params[:headline]
    
    writer_id = params[:writer_id]
    reviewer_id = params[:reviewer_id]

    # Constraint 2

    if ( !writer_id.nil? && !writer_id.eql?('') ) && writer_id == reviewer_id 

      flash[:danger] = "The Writer and the Reviewer cannot be the same."

      redirect_to request.referrer and return
    
    end

    story = Story.new

    # Constraint 4

    story.status = 'unassigned'

    if !writer_id.nil? && !writer_id.eql?('')
      # status = 'draft'
      story.status = 'draft'
    end

    # Does not creates with body because of: 
    # Constraint 5
    # Only writers can update the body of a story.

    story.headline = headline

    story.creator_id = current_user.id
    
    # Validates the writer_id

    if !writer_id.nil?
  
      writer_id = writer_id.delete('^0-9')

      if writer_id == ''

        writer_id = nil

      else

        writer_id = writer_id.to_i

      end

    else
      
      flash[:danger] = "Invalid Writer."

      redirect_to root_url and return

    end

    story.writer_id = writer_id

    # Validates the reviewer_id

    if !reviewer_id.nil?
  
      reviewer_id = reviewer_id.delete('^0-9')

      if reviewer_id == ''

        reviewer_id = nil

      else

        reviewer_id = reviewer_id.to_i

      end

    else
      
      flash[:danger] = "Invalid Writer."

      redirect_to root_url and return

    end

    story.reviewer_id = reviewer_id

    begin

      story.save  

      flash[:success] = "The Story has been created. "

    rescue => exception

      flash[:danger] = "The Story could not be created. "
      
    end

    redirect_to root_url

  end

  def edit

    # Get the page parameter
    story_id = params[:id]
    
    story_id = story_id.to_i

    @story = Story.find(story_id)

    writer = @story.writer

    if !writer.nil?

      @writer = @story.writer

    else

      @writer = Writer.new
      @writer.name = 'Not assigned yet'
    
    end

    reviewer = @story.reviewer

    if !reviewer.nil?

      @reviewer = @story.reviewer

    else

      @reviewer = Writer.new
      @reviewer.name = 'Not assigned yet'

    end

    if current_user.is_writer? 

      if ( current_user.id.to_i != @story.writer_id.to_i ) && ( current_user.id != @story.reviewer_id ) 

        flash[:danger] = "You don't have permission to access the content of this story."

        redirect_to root_url
      
      end

    end

    # Get all writers
    @writers = Writer.all   

  end

  def update

    # TODO: add validation with feedback

    headline = params[:headline]
    body = params[:body]

    writer_id = params[:writer_id]
    reviewer_id = params[:reviewer_id]

    story_id = params[:id]
    story_id = story_id.to_i


    # # Checks whether the page parameter is not null
    # if !story_id.nil?
      
    #   story_id = story_id.delete('^0-9')

    #   if story_id == ''

    #     redirect_to root_url and return

    #   else

    #     story_id = story_id.to_i

    #   end

    # else
    #   # If the page parameter is null we use 
    #   # the default page the first page

    #   # redirect_to root_url and return

    # end

    # Constraint 2

    if ( !writer_id.nil? && !writer_id.eql?('') ) && writer_id == reviewer_id 

      # TODO: add feedback
      flash[:danger] = "The Writer and the Reviewer cannot be the same."

      redirect_to request.referrer and return

    end

    story = Story.find( story_id )

    if ( ! story.writer_id.nil? ) && ( story.writer_id != writer_id.to_i )
      #  (!story.writer_id.eql?(writer_id))  
    #   #  && ( writer_id.nil? || writer_id.eql?('') )

    #   # TODO: enhance commment
    #   # After that writer is assigned, it's not possible unassing
    #   # TODO: add feedback

      flash[:danger] = "The Writer has already assigned."

      redirect_to request.referrer and return

    end

    # status = nil

    # Constraint 1.2
    if current_user.is_writer?
      
      # Constraint 8

      if story.status == 'pending'
      
        if !body.eql?(story.body)
          
          # If the body has changed  
          # status = 'draft'
          story.status = 'draft'
          
        end

      end

      story.headline = headline
      story.body = body
      
      # if !status.nil?
      #   story.status = status
      # end

      story.save

    elsif current_user.is_chief_editor?

      # Constraint 4

      if story.status == 'unassigned'

        if !writer_id.nil? && !writer_id.eql?('')
          # status = 'draft'
          story.status = 'draft'
        end

      end

      # Does not update the body because of: 
      # Constraint 5
      # Only writers can update the body of a story.

      # story = Story.new
      story.headline = headline
      story.writer_id = writer_id
      story.reviewer_id = reviewer_id

      # if !status.nil?
        
      #   story.status = status

      # end
      flash[:success] = "The story was successfully edited."
      story.save
   
    end

    redirect_to root_url

  end

  def status
    
    story_id = params[:id]
    story_id = story_id.to_i

    all_status = [ 'unassigned', 
                   'draft', 
                   'for_review', 
                   'in_review', 
                   'pending', 
                   'approved', 
                   'published', 
                   'archived' ]

    status = params[:status]

    if status.nil? || status.eql?('') || !all_status.include?(status)
      
      flash[:danger] = I18n.t 'invalid-status'

      redirect_to request.referrer

    end

    story = Story.find(story_id)

    if story.status == 'unassigned'

      # draft
      if status == 'draft'

        if current_user.is_writer?

          flash[:danger] = I18n.t 'no-permission-to-change-status'

          redirect_to request.referrer and return

        end

      else

        flash[:danger] = I18n.t 'invalid-change-of-status'
        
        redirect_to request.referrer and return

      end
    
    elsif story.status == 'draft'

      if status == 'for_review'
      
        # Constraint 6.1
        if current_user.id != story.writer_id

          flash[:danger] = I18n.t 'no-permission-to-change-status'

          redirect_to request.referrer and return

        end

      else

        flash[:danger] = I18n.t 'invalid-change-of-status'

        redirect_to request.referrer and return

      end

    elsif story.status == 'for_review'

      # in_review
      if status == 'in_review'

        # Constraint 7.1
        if current_user.id != story.reviewer_id

          flash[:danger] = I18n.t 'no-permission-to-change-status'

          redirect_to request.referrer and return

        end

      else

        flash[:danger] = I18n.t 'invalid-change-of-status'

        redirect_to request.referrer and return

      end

    elsif story.status == 'in_review'

      # pending
      if status == 'pending'

        # Constraint 7.1
        if current_user.id != story.reviewer_id

          flash[:danger] = I18n.t 'no-permission-to-change-status'

          redirect_to request.referrer and return

        end

      # approved
      elsif status == 'approved'

        # Constraint 7.1
        if current_user.id != story.reviewer_id

          flash[:danger] = I18n.t 'no-permission-to-change-status'

          redirect_to request.referrer and return

        end

      else

        flash[:danger] = I18n.t 'invalid-change-of-status'

        redirect_to request.referrer and return

      end

    elsif story.status == 'pending'

      flash[:danger] = I18n.t 'invalid-change-of-status'

      redirect_to request.referrer and return

    elsif story.status == 'approved'

      # published
      if status == 'published'

        if !current_user.is_chief_editor?

          flash[:danger] = I18n.t 'no-permission-to-change-status'

          redirect_to request.referrer and return

        end

      # archived
      elsif status == 'archived'

        if !current_user.is_chief_editor?

          flash[:danger] = I18n.t 'no-permission-to-change-status'

          redirect_to request.referrer and return

        end

      else

        flash[:danger] = I18n.t 'invalid-change-of-status'

        redirect_to request.referrer and return

      end     

    elsif story.status == 'published'

      # archived
      if status == 'archived'

        if !current_user.is_chief_editor?

          flash[:danger] = I18n.t  I18n.t 'no-permission-to-change-status'

          redirect_to request.referrer and return

        end

      else

        flash[:danger] = I18n.t 'invalid-change-of-status'

        redirect_to request.referrer and return

      end

    elsif story.status == 'archived'

      flash[:danger] = I18n.t 'invalid-change-of-status'

      redirect_to request.referrer and return

    end
   
    if status == 'for_review'
    
      flash[:success] = I18n.t 'review-requested'

    elsif status == 'in_review'

      flash[:success] = "Story in revision."

    elsif status == 'pending'

      flash[:success] = "Story pending."

    elsif status == 'approved'

      flash[:success] = "Story approved."

    elsif status == 'published'

      flash[:success] = "Story published."

    elsif status == 'archived'

      flash[:success] = "Story archived."

    end

    begin
      
      story.status = status
      story.save
  
    rescue => exception
      
    end

    redirect_to request.referrer and return

  end

end
