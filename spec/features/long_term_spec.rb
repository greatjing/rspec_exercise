require 'rails_helper'

feature "parking", :type => :feature do
  scenario "long_term parking" do
    # step1 登录
    user = User.create!( :email => "me@test.com", :password => "12345678" )
    sign_in(user)

    # step2 打开页面并点击长期费率
    visit "/"
    choose "长期费率"

    # 点击开始计费
    click_button "开始计费"

    # 点击结束计费
    click_button "结束计费"

    # 验证结果
    expect(page).to have_content("¥12.00 元")

  end
end
