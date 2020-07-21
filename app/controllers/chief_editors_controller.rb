class ChiefEditorsController < ApplicationController
  before_action :set_chief_editor, only: [:show, :edit, :update, :destroy]

  # GET /chief_editors
  # GET /chief_editors.json
  def index
    @chief_editors = ChiefEditor.all
  end

  # GET /chief_editors/1
  # GET /chief_editors/1.json
  def show
  end

  # GET /chief_editors/new
  def new
    @chief_editor = ChiefEditor.new
  end

  # GET /chief_editors/1/edit
  def edit
  end

  # POST /chief_editors
  # POST /chief_editors.json
  def create
    @chief_editor = ChiefEditor.new(chief_editor_params)

    respond_to do |format|
      if @chief_editor.save
        format.html { redirect_to @chief_editor, notice: 'Chief editor was successfully created.' }
        format.json { render :show, status: :created, location: @chief_editor }
      else
        format.html { render :new }
        format.json { render json: @chief_editor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chief_editors/1
  # PATCH/PUT /chief_editors/1.json
  def update
    respond_to do |format|
      if @chief_editor.update(chief_editor_params)
        format.html { redirect_to @chief_editor, notice: 'Chief editor was successfully updated.' }
        format.json { render :show, status: :ok, location: @chief_editor }
      else
        format.html { render :edit }
        format.json { render json: @chief_editor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chief_editors/1
  # DELETE /chief_editors/1.json
  def destroy
    @chief_editor.destroy
    respond_to do |format|
      format.html { redirect_to chief_editors_url, notice: 'Chief editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chief_editor
      @chief_editor = ChiefEditor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chief_editor_params
      params.require(:chief_editor).permit(:name, :email, :password, :password_confirmation, :type, :organization_id)
    end
end
