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
      commande = Command.create(:adress => row[0],:zipcode => row[1], :unit => row[4],:dateEnterFrom => row[2],:dateEnterTo => row[3],:commentaire => row[5])
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

      if commande.dateEnterFrom == nil || commande.dateEnterFrom.strftime("%d/%m/%Y") < DateTime.now.strftime("%d/%m/%Y") || commande.dateEnterTo == nil || commande.dateEnterTo.strftime("%d/%m/%Y") < DateTime.now.strftime("%d/%m/%Y")
        commande.dateFinalFrom = Time.now
        commande.dateFinalFrom = Time.now
        commande.dateEnterFrom = Time.now
        commande.dateEnterTo = Time.now
        commande.asap = 1
      end
      commande.save
    end
  end

end
