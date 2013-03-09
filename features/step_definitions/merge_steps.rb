# Add a declarative step here for populating the DB with movies.

And /the following articles exist:/ do |articles_table|
    articles_table.hashes.map do |article|
        Article.create!(
            :title => article[:title],
            :body => article[:body],
            :user_id => User.find_by_login(article[:author]).id
        )
    end
end

Given /I edit posts/ do
    visit "/admin/content"
end

And /I edit the article "(.*)"/ do |aid|
    visit "/admin/content/edit/" + aid
end

And /the following users exist:/ do |users_table|
    users_table.hashes.map do |user|
        User.create!(user)
    end
end


And /^the following comments exist:$/ do |comment_table|
  comment_table.hashes.map do |comment|
    Comment.create!(
      :article => Article.find_by_title(comment[:article_title]),
      :body => comment[:body],
      :author => comment[:author]
    )
  end
end

And /^I edit the article titled "(.*?)"$/ do |title|
    article_id = Article.find_by_title(title).id
    visit "/admin/content/edit/#{article_id}/"
end

Then /^I should see the field "(.*?)"$/ do |field_name|
    field_xpath = %Q(//form/input[@name='#{field_name}'])
    if page.respond_to? :should
        page.should have_xpath(field_xpath)
    else
        assert page.has_xpath?(field_xpath)
    end
end

Given /^I am logged in as "(.*?)"$/ do |login|
    visit '/accounts/login'
    fill_in 'user_login', :with => login
    fill_in 'user_password', :with => 'password'
    click_button 'Login'
    if page.respond_to? :should
        page.should have_content('Login successful')
    else
        assert page.has_content?('Login successful')
    end
end

Then /^I should not see the field "(.*?)"$/ do |field_name|
    field_xpath = %Q(//form/input[@name='#{field_name}'])
    if page.respond_to? :should_not
        page.should_not have_xpath(field_xpath)
    else
        assert ! page.has_xpath?(field_xpath)
    end
end

Given /^I merge the current article with the article titled "(.*?)"$/ do |title|
    article_id = Article.find_by_title(title).id
    page.fill_in 'merge_with', :with => article_id
    page.click_on 'Merge'
end

Then /^I should see the text "(.*?)"$/ do |text|
    if page.respond_to? :should
        page.should have_content(text)
    else
        assert page.has_content?(text)
    end
end

Then /^I can open the Categories page$/ do
    visit '/admin/categories/'
end
