### Unreleased

* Fix referral code default generator

### 0.2.1

* Change migrations to use Rails 6.1 version for compatibility

### 0.2.0

* Add `set_referral_cookie` controller method
* Add `rails g refer:install` generator to inject `set_referral_cookie`

### 0.1.1

* Added `dependent: :nullify` so ReferralCodes persist Referral records when deleted.
* Added `dependent: :destroy` so Referrals and ReferralCodes are deleted when users are deleted.
* Fixed missing `referral_codes` association on users

### 0.1.0

* Initial release
