class CreateCommands < ActiveRecord::Migration[5.1]
  def change
    create_table :commands do |t|
      t.string :usercommand
      t.string :adress
      t.integer :zipcode
      t.float :price
      t.integer :unit
      t.date :dateBegin
      t.date :dateEnd
      t.text :commentaire
      t.boolean :statewait
      t.boolean :statedone
      t.boolean :asap
      t.integer :user_id

      t.timestamps
    end
  end
end
