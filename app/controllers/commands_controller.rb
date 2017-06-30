class CommandsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_command, only: [:show, :edit, :update, :destroy]

  # GET /commands
  # GET /commands.json
  def index
    init(false,false)

  end

  def historique
    @commands
    if params[:search]
      if !current_user.admin?
        @commands = Command.search(params[:search]).where({usercommand: current_user})
      else
        @commands = Command.search(params[:search])
      end
    else
      if !current_user.admin?
        @commands = Command.all.where({usercommand: current_user}).order(params[:dateBegin]).reverse_order
      else
        @commands = Command.all.order(params[:dateBegin]).reverse_order
      end
    end
    front_date(@commands)
  end

# gestion des affichage par dateBegin
  def front_date (list)
    @listDate = []
    if !list.empty?
      @listDate.push(list.first.dateBegin)
      dateBefore = list.first.dateBegin
      list.each do |commande|
        if commande.dateBegin != dateBefore
          dateBefore=commande.dateBegin
          @listDate.push(commande.dateBegin)
        end
      end
    end
  end

  def init (condition1, condition2)


    @prixTotal=0
    @commands = []
    @tmpcommands = Command.all.order(params[:dateBegin])


    # gestion des affichages des commandes par trie d'admin et d'état

    @tmpcommands.each do |command|
      if (command.statewait == condition1 && command.statedone == condition2)
        if !current_user.admin?
          if command.user_id == current_user.id
            @commands.push(command)
          end
        else
          @commands.push(command)
        end
      end
    end
    # Affichage du total du prix
    @commands.each do |commande|
      @prixTotal += commande.price * commande.unit
    end
    front_date(@commands)
  end

  def during
    commands = []
    @commands = Command.all.order(params[:dateBegin])

    @prixTotal=0

    @commands.each do |command|
      if (command.statewait == true || command.statedone == true)
        if !current_user.admin?
          if command.user_id == current_user.id
            commands.push(command)
          end
        else
          commands.push(command)
        end
      end
    end
    commands.each do |commande|
      @prixTotal += commande.price * commande.unit
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
  def create_import
    @user=current_user
    @command = @user.commands.new(command_params)
    @command.statewait=false
    @command.statedone=false
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

  def create

    @user=current_user

    @command = @user.commands.new(command_params)
    @command.statewait=false
    @command.statedone=false
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

  def import
    current_user.commands.import(params[:file])
  end

  def export

    commands = Command.all.where({dateBegin: "2017-06-31"})
    commands.each do |c|
      if current_user.admin != true
        commands = Command.all.where({dateBegin: "2017-06-30",usercommand: current_user.username})
      end
    end
    if !commands.nil?
      respond_to do |format|
        format.html
        format.csv { send_data commands.to_csv }
        #format.xls # { send_data @products.to_csv(col_sep: "\t") }
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
    def file_params
      params.require(:command).permit(:adress,:zipcode,:unit,:dateBegin,:commentaire)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def command_params

        params.require(:command).permit(:adress,:zipcode,:unit,:dateBegin,:commentaire,:statewait,:statedone)

    end
end
