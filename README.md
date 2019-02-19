# Pushup Metrics
Do pushups. Get Stronger. http://www.pushupmetrics.com

## Installation

1. Clone repo
2. With [Postgres](http://postgresapp.com/) running,  ```$ bundle && bundle exec rake db:setup && rake db:migrate```
3. Get `config/application.yml` from repo admin or start over with `config/application.yml.sample`

## To Do

* Optimize SQL queries (e.g. `dashboard_controller#team`)
* Refactor team subdomains
* Remove front-end hacks for date/time dropdown pickers (`views/reminders/_form`)
* Twilio alerts not firing for all users, perhaps not catching all errors, thus dying
* Portal for creating, managing teams and ability to invite team members
* Weekly / monthly / annual projection alerts based on user's growth rate
* What else?

## Changelog

* Feb '19, global leaderboard at /leaderboard
* July '16, weekly digest email (who beat their personal best, by how much)
* Aug '16, Calorie Counter, random messages added by [baconck](https://github.com/baconck)

## Why contribute?

* ~400 users and growing
* 250,000+ pushups logged (February 2019)
* Interactive: weekly emails, SMS alerts, + 3rd party APIs integrated

## Contributors

[Ryan Kulp](https://www.ryanckulp.com), [Chris Bacon](https://github.com/baconck), you?
