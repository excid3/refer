class CreateReferVisits < ActiveRecord::Migration[7.2]
  def change
    create_table :refer_visits do |t|
      t.belongs_to :referral_code, null: false, foreign_key: { to_table: :refer_referral_codes }
      t.string :ip
      t.text :user_agent
      t.text :referrer
      t.string :referring_domain

      t.timestamps
    end
  end
end
