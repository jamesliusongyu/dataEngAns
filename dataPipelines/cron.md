crontab
# this will output the time taken to the log file, so we can debug if need be.
# scheduled at 1am because probably 1am is a good time to run jobs because production is less busy where everyone is sleeping.

0 1 * * * time ./datapipelines.sh >> datapipelines+`date`.log
