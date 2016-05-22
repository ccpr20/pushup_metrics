# Pushup Tracker
Do pushups. Get Stronger.

## Installation
1. Clone repo
2. With [Postgres](http://postgresapp.com/) running,  ```$ rake db:setup``` then ```$ rake db:migrate```
3. Get config/application.yml from repo admin for ENV keys (if applicable)

## To Dos
* Speed up / reduce SQL queries on team dashboard (controllers/dashboard_controller.rb, team)
* Refactor subdomain creation / exclusion (currently hacky, looks at url)
* Remove front-end hacks for date/time dropdown pickers (views/reminders/_form)
* Twilio alerts not firing for all users, perhaps not catching all errors, thus dying
* Build a portal for creating, managing teams and ability to invite team members
* Calorie counter
* Weekly / monthly / annual projection alerts based on user's growth rate
* What else?

## Why commit?
* ~200 users, growing daily
* 78,000 pushups logged
* Interactive: digest emails, SMS alerts, + 3rd party APIs integrated
