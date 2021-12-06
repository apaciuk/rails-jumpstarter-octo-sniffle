require "fileutils"
require "shellwords"

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("jumpstarter-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/whatapalaver/jumpstarter.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{jumpstarter/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def rails_version
  @rails_version ||= Gem::Version.new(Rails::VERSION::STRING)
end


def add_gems
  gem 'pg'
  gem 'font-awesome-sass', '~> 5.15.1'
end

def add_test_gems
  gem_group :test do
    gem 'capybara-screenshot'
    gem 'cucumber-rails', require: false
    gem 'database_cleaner'
    gem 'rails-controller-testing'
  end

  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'factory_bot_rails'
    gem 'shoulda-matchers'
    gem 'webdrivers'
    gem 'faker'
  end
end

def pg_db
  # config the app to use postgres
  remove_file 'config/database.yml'
  template 'database.erb', 'config/database.yml'
end

def yarn(lib)
  run("yarn add #{lib}")
end

def set_application_name
  # Add Application Name to Config
  environment "config.application_name = Rails.application.class.module_parent_name"

  # Announce the user where they can change the application name in the future.
  puts "You can change application name inside: ./config/application.rb"
end


def add_javascript
  yarn("bootstrap@next")
  yarn("@popperjs/core")
  yarn ("@fortawesome/fontawesome-free")
end

def copy_templates
  copy_file "Procfile"
  copy_file "Procfile.dev"
  copy_file ".foreman"

  directory "app", force: true
  directory "config", "config", force: true
  directory "lib", force: true

  route "get '/terms', to: 'home#terms'"
  route "get '/privacy', to: 'home#privacy'"
end

def copy_features
  directory "features", "features", force: true
end

def stop_spring
  run "spring stop"
end


def update_readme
  template = """
    ## To get started with your new app

    - cd {app_name}
    - Update config/database.yml with your database credentials
    - rails db:create db:migrate
    - gem install foreman
    - foreman start

    ### Running your app

    To run your app, use `foreman start`. Foreman will run `Procfile.dev` via `foreman start -f Procfile.dev` as configured by the `.foreman` file and will launch the development processes `rails server`, and `webpack-dev-server` processes. 
    You can also run them in separate terminals manually if you prefer.
    A separate `Procfile` is generated for deploying to production on Heroku.

    
    ### Testing

    The app is set up for BDD using cucumber. Just run `cucumber` to be woalked through the process.

    ### Cleaning up

    ```bash
    rails db:drop
    spring stop
    cd ..
    rm -rf myapp
    ```
    """.strip
    insert_into_file 'README.md', "\n" + template, after: "# README"  
end

# Main setup
add_template_repository_to_source_path

add_gems
add_test_gems

after_bundle do
  set_application_name
  stop_spring
  add_javascript

  copy_templates
  pg_db
  update_readme

  rails_command "active_storage:install"
  rails_command "generate rspec:install"
  rails_command "generate cucumber:install"

  copy_features

  # Commit everything to git
  unless ENV["SKIP_GIT"]
    git :init
    git add: "."
    # git commit will fail if user.email is not configured
    begin
      git commit: %( -m 'Initial commit' )
    rescue StandardError => e
      puts e.message
    end
  end

  say
  say "Jumpstarter app successfully created!", :blue
  say
  say "To get started with your new app:", :green
  say "  cd #{app_name}"
  say
  say "  # Update config/database.yml with your database credentials"
  say
  say "  rails db:create db:migrate"
  say "  rails g madmin:install # Generate admin dashboards"
  say "  gem install foreman"
  say "  foreman start # Run Rails, sidekiq, and webpack-dev-server"
end
