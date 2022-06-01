#! /bin/bash
(crontab -l 2>/dev/null; echo "*/5 * * * * bash $HOME/WeatherData.sh") | crontab
(crontab -l 2>/dev/null; echo "58 23 * * * bash $HOME/WeatherReportV3.sh") | crontab
sudo service cron start