#
# Regular cron jobs for the rfcreader package
#
0 4	* * *	root	[ -x /usr/bin/rfcreader_maintenance ] && /usr/bin/rfcreader_maintenance
