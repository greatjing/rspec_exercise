require 'rails_helper'

feature "parking", :type => :feature do
  scenario "guest parking" do
    # step 1 打开首页
    visit "/"
    # 检查打开html页面
    expect(page).to have_content("一般计费")

    # step 2 点击开始计费按钮
    click_button "开始计费"

    # step 3 点击结束计费按钮
    click_button "结束计费"

    # 看到费用画面
    expect(page).to have_content("¥2.00 元")

  end
end
