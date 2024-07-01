class CreateReferReferralCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :refer_referral_codes do |t|
      t.belongs_to :referrer, polymorphic: true, null: false
      t.string :code, null: false, index: { unique: true }
      t.integer :referrals_count, default: 0
      t.integer :visits_count, default: 0

      t.timestamps
    end
  end
end
