require 'rails_helper'

feature "register and login", :type => :feature do

  scenario "register" do
    # step1 浏览注册页面
    visit "/users/sign_up"

    expect(page).to have_content("Sign up")

    # step2 填表格
    within("#new_user") do
      fill_in "Email", with: "me@test.com"
      fill_in "Password", with: "12345678"
      fill_in "Password confirmation", with: "12345678"
    end

    # step3 点击登录按钮
    click_button "Sign up"
    expect(page).to have_content("Welcome! You have signed up successfully")

    # 检查是否注册成功
    user = User.last
    expect(user.email).to eq("me@test.com")

  end

end
