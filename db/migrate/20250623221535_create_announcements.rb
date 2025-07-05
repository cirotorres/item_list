class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.string :type

      t.timestamps
    end
  end
end
