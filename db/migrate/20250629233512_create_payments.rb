class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.string :mp_payment_id
      t.string :status
      t.string :status_detail

      t.timestamps
    end
  end
end
