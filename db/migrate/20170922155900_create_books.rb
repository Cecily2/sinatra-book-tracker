class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.integer :isbn
      t.string :name
      t.string :author
      t.string :cover
      t.integer :rating
      t.string :comments
      t.boolean :read
      t.datetime :date_read
      t.integer :user_id
    end
  end
end
