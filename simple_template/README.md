# Jumpstarter Rails Template

All your Rails apps should start off with a bunch of great defaults.

This started as the great Jumpstart template from GoRails, I'm just tweaking it for my own needs.
Want to see how the original works? Check out [the Jumpstart walkthrough video](https://www.youtube.com/watch?v=ssOZpISfIfI):

[![Jumpstart Ruby on Rails Template Walkthrough](https://i.imgur.com/pZDPbc7l.png)](https://www.youtube.com/watch?v=ssOZpISfIfI)

## Changes to the original jumpstart template

- For use with Rails 6 only
- Bootstrap 5 support (no JQuery)
- Added BDD testing support with cucumber and includes some starter features
- Set pg as default database (if you don't want this just comment out the command pg_db in template.rb)

## Getting Started

Jumpstarter is a Rails template, so you pass it in as an option when creating a new app.

### Requirements

You'll need the following installed to run the template successfully:

* Ruby 2.5 or higher
* Redis - For ActionCable support
* bundler - `gem install bundler`
* rails - `gem install rails`
* Yarn - `brew install yarn` or [Install Yarn](https://yarnpkg.com/en/docs/install)
* Foreman (optional) - `gem install foreman` - helps run all your
  processes in development

### Creating a new app

Download this repo, so you can reference template.rb locally:

```bash
rails new myapp -m path_to/template.rb
```

❓Having trouble? Try adding `DISABLE_SPRING=1` before `rails new`. Spring will get confused if you create an app with the same name twice.

### Running your app

To run your app, use `foreman start`. Foreman will run `Procfile.dev` via `foreman start -f Procfile.dev` as configured by the `.foreman` file and will launch the development processes `rails server`, `sidekiq`, and `webpack-dev-server` processes. 

You can also run them in separate terminals manually if you prefer.

A separate `Procfile` is generated for deploying to production on Heroku.

### Authenticate with social networks

We use the encrypted Rails Credentials for app_id and app_secrets when it comes to omniauth authentication. Edit them as so:

```
EDITOR=vim rails credentials:edit
```

Make sure your file follow this structure:

```yml
secret_key_base: [your-key]
development:
  github:
    app_id: something
    app_secret: something
    options:
      scope: 'user:email'
      whatever: true
production:
  github:
    app_id: something
    app_secret: something
    options:
      scope: 'user:email'
      whatever: true
```

With the environment, the service and the app_id/app_secret. If this is done correctly, you should see login links
for the services you have added to the encrypted credentials using `EDITOR=vim rails credentials:edit`

### Cleaning up

```bash
rails db:drop
spring stop
cd ..
rm -rf myapp
```
