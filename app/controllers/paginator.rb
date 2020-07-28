class Paginator
  # private_class_method :new

  # @limit = nil
  # @delta = nil
  # @total_of_records = nil
  # @page = nil
  # @page = nil
  # @min_page = nil
  # @max_page = nil
  # @max_pages = nil
  # @previous_page = nil
  # @next_page = nil
  # @offset = nil

  def self.call(*args)
    new(*args).call
  end

  # def initialize()
  # end

  def initialize(total_of_records, page)
    
    @limit = 3
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

    @offset = (@page - 1) * @limit
    
    @min_page = @page - @delta

    if @min_page <= 0
      @min_page = 1
    end

    @max_page = @page + @delta

    if @max_page > @max_pages
      @max_page = @max_pages
    end

    @previous_page = @page - 1

    if @previous_page <= 0
      @previous_page = 1
    end

    @next_page = @page + 1

    if @next_page > @max_pages
      @next_page = @max_page
    end

    if @page == @max_pages
      @showing = @total_of_records - (( @max_pages-1 )*@limit)
    else
      @showing = @limit      
    end

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