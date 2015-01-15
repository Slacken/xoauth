require 'mongoid'
require 'mongoid/xoauth'
require 'oauth'

class User
  include Mongoid::Document
  include Mongoid::Xoauth

  xoauth weibo: {key: 'xxx', secret: 'xxx'}
end


describe Mongoid::Xoauth, 'Mongoid::Coauth' do
  it "should include coauth" do
    user = User.new
    user.oauths << Oauth::Weibo.new
    expect(Oauth::Configure.value["weibo"]).to_not eq(nil)
  end
end

describe Oauth::Provider, "oauth provider" do
  it "should contains methods" do
    expect(Oauth::Provider.methods.include?(:get)).to eq(true)
    expect(Oauth::Provider.methods.include?(:postJSON)).to eq(true)
  end
end