# Pushup Metrics
Do pushups. Get Stronger. http://www.pushupmetrics.com

## Installation
1. Clone repo
2. With [Postgres](http://postgresapp.com/) running,  ```$ bundle && rake db:setup && rake db:migrate```
3. Get `config/application.yml` from repo admin

## To Do
* Optimize SQL queries on team dashboard (controllers/dashboard_controller.rb, team action)
* Refactor team subdomains
* Remove front-end hacks for date/time dropdown pickers (views/reminders/_form)
* Twilio alerts not firing for all users, perhaps not catching all errors, thus dying
* Portal for creating, managing teams and ability to invite team members
* Weekly / monthly / annual projection alerts based on user's growth rate
* What else?

## Changelog
* July '16, weekly digest email (who beat their personal best, by how much)
* Aug '16, Calorie Counter, random messages added by [baconck](https://github.com/baconck)


## Why contribute?
* ~200 users, growing daily
* 95,500 pushups logged (August 2016)
* Interactive: weekly emails, SMS alerts, + 3rd party APIs integrated

## Contributors
[Ryan Kulp](http://www.ryanckulp.com), [Chris Bacon](https://github.com/baconck), you?
