class CreateReferReferrals < ActiveRecord::Migration[7.2]
  def change
    create_table :refer_referrals do |t|
      t.belongs_to :referrer, polymorphic: true, null: false
      t.belongs_to :referee, polymorphic: true, null: false
      t.belongs_to :referral_code

      t.timestamps
    end
  end
end
