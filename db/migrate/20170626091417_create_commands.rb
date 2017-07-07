class CreateCommands < ActiveRecord::Migration[5.1]
  def change
    create_table :commands do |t|
      t.string :usercommand
      t.string :adress
      t.integer :zipcode
      t.float :price
      t.integer :unit
      t.datetime :dateEnterFrom
      t.datetime :dateEnterTo
      t.datetime :dateModifFrom
      t.datetime :dateModifTo
      t.datetime :dateFinalFrom
      t.datetime :dateFinalTo
      t.text :commentaire
      t.boolean :statewait
      t.boolean :statedone
      t.boolean :asap
      t.integer :user_id

      t.timestamps
    end
  end
end
