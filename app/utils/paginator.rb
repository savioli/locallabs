class Paginator

  def initialize(total_of_records, page, limit)
    
    @limit = 7
    @delta = 4
    @total_of_records = total_of_records
    @page = page
    @min_page = 1
    @max_page = 1
    @max_pages = 1
    @previous_page = 1
    @next_page = 1
    @offset = 1
    @first_page = 1
    @showing = 1

    self.compute()

  end

  def compute()

    # Calculates the maximum page
    @max_pages = @total_of_records.to_f / @limit.to_f
    @max_pages = @max_pages.ceil

    # Calculates the offset
    @offset = (@page - 1) * @limit
    
    # Calculates the min page
    @min_page = @page - @delta

    if @min_page <= 0
      @min_page = 1
    end

    # Calculates the max page
    @max_page = @page + @delta

    if @max_page > @max_pages
      @max_page = @max_pages
    end

    # Calculates the previous
    @previous_page = @page - 1

    if @previous_page <= 0
      @previous_page = 1
    end

    # Calculates the next
    @next_page = @page + 1

    if @next_page > @max_pages
      @next_page = @max_page
    end

    # Calculates the number of records being shown
    if @page == @max_pages
      @showing = @total_of_records - (( @max_pages-1 )*@limit)
    else
      @showing = @limit      
    end

    # Particular case
    if @max_pages == 0
      @max_pages = 1
      @next_page = 1
      @max_page = 1
    end
    
  end

  # private

  attr_accessor :total_of_records, 
                :page, 
                :limit, 
                :delta, 
                :min_page, 
                :max_page, 
                :max_pages, 
                :previous_page, 
                :next_page, 
                :offset, 
                :first_page,
                :showing

end