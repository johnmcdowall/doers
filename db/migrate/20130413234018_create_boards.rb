class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :title
      t.integer :position
      t.references :user, index: true
      t.references :project, index: true
      t.references :panel, index: true
      t.string :status

      t.timestamps
    end
  end
end