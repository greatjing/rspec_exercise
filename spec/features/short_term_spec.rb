require 'rails_helper'

feature "parking", :type => :feature do
  scenario "short_term parking" do
    # step1 用户登录
    user = User.create!( :email => "me@test.com", :password => "12345678" )
    sign_in(user)

    # step2  打开页面并且选择短期计费
    visit "/"
    choose "短期费率"

    # step3 点击开始计费
    click_button "开始计费"

    # step4 点击结束计费
    click_button "结束计费"

    # 验证结果
    expect(page).to have_content("¥2.00 元")

  end
end
