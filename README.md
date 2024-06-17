# Refer

Referral codes and affiliate links for Ruby on Rails applications.

## 📦 Installation
Add this line to your application's Gemfile:

```ruby
gem "refer"
```

And then execute:
```bash
$ bundle
```

Add Refer to your controllers to store referral cookies:
```bash
bin/rails generate refer:install
```

And add Refer to your model:
```bash
bin/rails generate refer:model User
bin/rails db:migrate
```

## 🧑‍💻 Usage

Refer adds a models to your Rails application for tracking referrals and referral codes.

To track referrals, you'll need to

1. Create a referral code
2. Set a cookie with the referral code
3. Create the referral
4. (Optional) Provide a reward for successful referral

##### Create a referral code

You can create referral codes through the association:

```ruby
user.referral_codes.create #=> randomly generated code
user.referral_codes.create(code: "chris")
```

To customize the referral code generator:

```ruby
Refer.code_generator = ->(referrer) { [id, SecureRandom.alphanumeric(8)].join("-") }
#=> generates codes like "1-7frb5fUw"
```

By default, Refer will generate 8 character alphanumeric codes.

##### Set a referral cookie

To track users, we need to stash the referral code in a cookie when present. By default, Refer will look for `?ref=code` and save this in a cookie.

```ruby
class ApplicationController < ActionController::Base
  set_referral_cookie
end
```

Move `set_referral_cookie` to specific controllers if you'd only like cookies set in certain areas like marketing pages for example.

```ruby
class MarketingController < ActionController::Base
  set_referral_cookie except: [:about_us]
end
```

You can customize the param name with:

```ruby
Refer.param_name = :ref
```

You can customize the cookie name with:

```ruby
Refer.cookie_name = :refer_code
```

##### Refer a user:

To create a referral, you can run the following

```ruby
class RegistrationsController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      refer @user #=> Looks up cookie and attempts referral
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end
end
```

You can also do this manually:

```ruby
Refer.refer(code: "referral_code", referee: user)
```

Refer will make sure the user has not already been referred and create a Referral.

##### Check if a user was referred already:

```ruby
Refer.referred?(user)
#=> true/false
```

##### Accessing Referrals

To access a user's referrals, you can use the `referrals` association:

```ruby
user.referrals #=> [Refer::Referral, Refer::Referral]
```

This returns a list of `Refer::Referral` objects.

##### Accessing Referral

To access a user's referral, you can use the `referral` association:

```ruby
user.referral #=> Refer::Referral
```

To access a user's referrer, you can use `referrer`:
```ruby
user.referrer #=> User that referred this User
```
## Refer with Devise

To use Refer with Devise, you'll need to customize the Devise controller to track the referral after a successful registration.

We can do this by telling Devise to use a custom controller in the routes and hooking into the `create` action to track the referral.

```ruby
# config/routes.rb
devise_for :users, controllers: { registrations: "users/registrations" }
```

```ruby
# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do
      refer resource if resource.persisted?
    end
  end
end
```

## Providing Referral Rewards

There are several common ways of handling rewards for successful referrals:

* Immediate rewards
When the referral is successfully created, you can immediately credit the referrer with their reward.

* Reward after user actions
You can check if a user was referred after they complete the action and provide a reward to the referrer.

* Time-based rewards
To provide a reward X days after a successful referral, you can use a schedule job to check for referrals X days ago and provide rewards to those referrers.

We recommend keeping records for each reward given to a referral so you can limit rewards.

## 🙏 Contributing
If you have an issue you'd like to submit, please do so using the issue tracker in GitHub. In order for us to help you in the best way possible, please be as detailed as you can.

## 📝 License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
