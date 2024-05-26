FROM mcr.microsoft.com/playwright:v1.44.1-jammy

WORKDIR /usr/src/microsoft-rewards-script

COPY . .

RUN npm install

RUN npm run build

# Install cron
RUN apt-get update && apt-get install -y cron tzdata python3 python3-pip
RUN pip3 install croniter

# Give execution rights to run_daily.sh
RUN chmod +x /usr/src/microsoft-rewards-script/src/run_daily.sh

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Copy the entrypoint script
COPY entrypoint.sh /usr/src/microsoft-rewards-script/entrypoint.sh
RUN chmod +x /usr/src/microsoft-rewards-script/entrypoint.sh

CMD sh -c 'echo "$TZ" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata'

# Run the entrypoint script on container startup
CMD /bin/bash /usr/src/microsoft-rewards-script/entrypoint.sh
