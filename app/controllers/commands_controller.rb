class CommandsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_command, only: [:show, :edit, :update, :destroy]

  # GET /commands
  # GET /commands.json
  def index
    @commandes = []
    @commands = Command.all.order(params[:dateBegin])
    @prixTotal=0

    @commands.each do |command|
      if !current_user.admin?
        if command.user_id == current_user.id
          @commandes.push(command)
        end
      else
        @commandes.push(command)
      end
    end
    @commandes.each do |commande|
      @prixTotal += commande.price
    end

  end

  # GET /commands/1
  # GET /commands/1.json
  def show
  end

  # GET /commands/new
  def new
    @user=current_user
    @command = current_user.commands.new
  end

  # GET /commands/1/edit
  def edit
  end

  # POST /commands
  # POST /commands.json
  def create
    #@commandUser(:id)=User.find(:id)
    @user=current_user
    @command = @user.commands.new(command_params)
    if @command.zipcode.present?
      if (@command.zipcode > 75000) && (@command.zipcode < 75021)
        @command.price = current_user.price1
      else
        @command.price = current_user.price2
      end
    end
    @command.usercommand = current_user.username

    if @command.dateBegin == nil || @command.dateBegin < DateTime.now
      @command.dateBegin = Time.now.strftime("%d/%m/%Y")
      @command.asap = 1
    end

    respond_to do |format|
      if @command.save
        format.html { redirect_to @command, notice: 'Command was successfully created.' }
        format.json { render :show, status: :created, location: @command }
      else
        format.html { render :new }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commands/1
  # PATCH/PUT /commands/1.json
  def update
    respond_to do |format|
      if @command.update(command_params)
        format.html { redirect_to @command, notice: 'Command was successfully updated.' }
        format.json { render :show, status: :ok, location: @command }
      else
        format.html { render :edit }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commands/1
  # DELETE /commands/1.json
  def destroy
    @command.destroy
    respond_to do |format|
      format.html { redirect_to commands_url, notice: 'Command was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_command
      @command = Command.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def command_params
      params.require(:command).permit(:adress,:zipcode,:unit,:dateBegin, :state, :commentaire)
    end
end
