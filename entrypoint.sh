#!/bin/bash

# Set up environment variables
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

# Check if RUN_ON_START is set to true and execute the script immediately
if [ "$RUN_ON_START" = "true" ]; then
  echo "RUN_ON_START is set to true, executing run_daily.sh immediately..."
  /usr/src/microsoft-rewards-script/src/run_daily.sh
fi

# Create a crontab file with the specified schedule
echo "${CRON_SCHEDULE} /usr/src/microsoft-rewards-script/src/run_daily.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/crontab

# Apply cron job
crontab /etc/cron.d/crontab

# Give execution rights on the cron job
chmod 0644 /etc/cron.d/crontab

# Calculate and display the next execution time using croniter
NEXT_RUN=$(python3 -c "
from croniter import croniter
from datetime import datetime
schedule = '${CRON_SCHEDULE}'
base_time = datetime.now()
print('Current time:', base_time.strftime('%Y-%m-%d %H:%M:%S'))
iter = croniter(schedule, base_time)
print('Next job scheduled at:', iter.get_next(datetime).strftime('%Y-%m-%d %H:%M:%S'))
")

echo "$NEXT_RUN"

# Start cron
cron

# Keep the container running
tail -f /var/log/cron.log
