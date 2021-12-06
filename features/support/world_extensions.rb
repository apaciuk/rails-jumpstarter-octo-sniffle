module CommonUser
  def register
    visit('/')
    within(".navbar") do
      click_on('Sign Up')
    end
    fill_in 'user_name', with: 'Erica Jong'
    fill_in 'user_email', with: 'example@example.com'
    fill_in 'user_password', with: 'password123'
    fill_in 'user_password_confirmation', with: 'password123'
    find('input[name="commit"]').click
  end

  def logout
    click_on('Logout')
  end

  def login
    visit('/')
    within(".navbar-text") do
      click_on('Login')
    end
    fill_in('Email', with: 'example@example.com')
    fill_in('Password', with: 'password123')
    find('input[name="commit"]').click
  end

end

World(CommonUser)