WoodiesSlack = Slack::Notifier.new ENV['WOODIES_SLACK_WEBHOOK'] if ENV['WOODIES_SLACK_WEBHOOK']
