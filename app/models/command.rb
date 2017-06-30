class Command < ApplicationRecord
  belongs_to :user

  validates :adress, presence: true
  validates :zipcode, presence: true, numericality: true
  validates_length_of :zipcode, is: 5
  validates :unit, presence: true, numericality: true

  


  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |command|
        csv << command.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)

    CSV.foreach(file.path, headers: true) do |row|
      commande = Command.create(:adress => row[0],:zipcode => row[1], :unit => row[3],:dateBegin => row[2],:commentaire => row[4])
      user = User.find(commande.user_id)
      commande.statewait=false
      commande.statedone=false
      if commande.zipcode.present?
        if (commande.zipcode > 75000) && (commande.zipcode < 75021)
          commande.price = user.price1
        else
          commande.price =  user.price2
        end
      end
      commande.usercommand = user.username

      if commande.dateBegin == nil || commande.dateBegin < DateTime.now
        commande.dateBegin = Time.now.strftime("%d/%m/%Y")
        commande.asap = 1
      end
      commande.save
    end
  end

end
