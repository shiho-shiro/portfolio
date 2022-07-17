module LoginModule
  def login(user)
    visit root_path
    click_link 'ログイン'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'ログイン'
  end
end
