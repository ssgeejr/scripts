## Crontab examples

The crontab is a formatted list of commands that you want to run on a regular schedule. crontab stands for "cron table," because it uses the job scheduler cron to execute tasks; cron itself is named after "chronos," the Greek word for time.

These are not all of the commands, but the ones you should know [for a list of all the commands google 'man crontab']
`crontab -e`	Edit your crontab file, or create one if it doesn't already exist [this is the command to open the editor^1]
`crontab -l`	Display your crontab file.
`crontab -v`	Display the last time you edited your crontab file. (This option is available on only a few systems.)


```
+------------- min (0 - 59)
| +----------- hour (0 - 23)
| | +--------- day of        month (1 - 31)
| | | +------- month (1 - 12)
| | | | +----- day of week (0 - 6) (Sunday=0)
| | | | |
- - - - -
* * * * *   command to be executed
```
Cron helpful tips:

Example

`0 4 * * 0  python /opt/bin/cleanupOldRepoObjects.py >> /var/log/awsArtifactoryScrubber.log 2>&1`

Understanding the time configuration:

On the minute: `0` 

On the hour: `4 am`

`Every day`

`Every month`

on day: `Sunday`

Execute this command: `python /opt/bin/cleanupOldRepoObjects.py`

Append to the log file:  `>> `

If you wanted to overwrite the log file every time you would use: `>`

write to the log file: `/var/log/awsArtifactoryScrubber.log`

[Very important to learn this at some point in your devops career]

Send err stream to the output locatino of stdout

*What?* 

send the err stream:  `2`

Redirect it away from the console: `>`

To the same target as stdout [1]: `&1` 


^1 you may need to set your editor: export EDITOR=vim
