# swapp


## Project Overview
swapp is a web application that helps SWAP (Severe Weather Action Plan) caseworkers perform intake for people experiencing homelessness, so that they can find shelter during periods of inclement weather.

## Setup Instructions

### Environment Setup
First, install the following:

1. [Ruby](https://www.ruby-lang.org/en/documentation/installation) - This project uses version `3.1.5`. You can use [rbenv](https://github.com/rbenv/rbenv) to easily manage your local ruby version: `rbenv install 3.1.5` 
1. [Ruby on Rails](https://guides.rubyonrails.org/v5.0/getting_started.html#installing-rails)
1. [Node.JS and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm#checking-your-version-of-npm-and-node-js)
1. [postgres](https://www.postgresql.org/download/)

### Set up the repo
1. Within your terminal, clone this repo to your local machine: `git clone git@github.com:mostlyerror/swapp.git`
1. `cd swapp`
1. Install Ruby gems: `bundle install`

### Install Tailwind CSS v2.0
1. Install some node packages to provide the best CSS compatibility possible. Run `npm install tailwindcss@npm:@tailwindcss/postcss7-compat postcss@^7 autoprefixer@^9`

### Install webpacker
1. Install webpacker with `rails webpacker:install`

### Set up the database
1. Run the following:
    - `rails db:create`
    - `rails db:migrate` - this runs all of the migrations listed in `db/migrate`
    - `rails db:seed` - this runs the seed script (`db/seeds.rb`), which loads the app's seed data


### API Keys

In order to send vouchers electronically, obtain credentials by creating accounts with [Twilio](https://www.twilio.com/) and [SendGrid](https://sendgrid.com/)


Once you have those set up: 
- Create a `.env` file in the project's root directory (if not already present).
- Then open your `.gitignore` file and add `.env`. 
- Open your `.env` file and add the following:
```
TWILIO_SID=YOUR_TWILIO_SID
TWILIO_TOKEN=YOUR_TWILIO_TOKEN
TWILIO_NUMBER=YOUR_TWILIO_NUMBER
SENDGRID_API_KEY=YOUR_API_KEY
```

> :warning: :warning: ***Double check that `.env` has been added to your .gitignore file to avoid uploading sensitive data. DO NOT UPLOAD YOUR .ENV FILE TO GITHUB*** :warning: :warning:

### Development Credentials

You can read more about them [here](https://medium.com/cedarcode/rails-5-2-credentials-9b3324851336).

Essentially, you can run `EDITOR=vim rails credentials:edit` to open your encrypted credentials file. Once you save it, a `config/master.key` file will be available, which is the file you will need to modify your credentials in the future. Keep track of the contents of this file because you will need to generate a new one if you lose it (and add any secrets).

### Run the app
1. Run `rails server` to start the app
2. In a separate process, run `./bin/webpack-dev-server`
3. Navigate to `http://localhost:3000` to view.

## Deployment Instructions
TODO: Heroku setup, pipeline configuration, etc.

