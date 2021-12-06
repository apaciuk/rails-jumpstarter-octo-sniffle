Given('I am on the home page') do
  visit '/'
end

Given('I submit my registration') do
  register
end


Then('I should see confirmation that I have signed up') do
  expect(page).to have_content("You have signed up successfully")
end