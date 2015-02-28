# Oauth

Chinese Social network (weibo/qq/weixin currently) authentication with mongoid.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xoauth', :require => 'oauth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xoauth

## Usage

```ruby
class User
  include Mongoid::Document
  include Mongoid::Xoauth

  xoauth weibo: {'appid'=> '1112', 'secret'=> '123dffd'}
end
```

Then we can use the following methods:

```ruby
  # get the found user or nil
  User.find_by_oauth_uid(uid, Oauth::Weibo)
  
  # authorize url
  Oauth::Weibo.authorize_url
  
  # detail of code: {access_token, uid, created_at, expires_in}
  # can be used to initialize Oauth::Weibo
  Oauth::Weibo.detail_of_code(code)

  # fetch the detail infomation of the oauth client
  Oauth::Weibo#fetch_info!

```

## Contributing

1. Fork it ( https://github.com/Slacken/xoauth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
