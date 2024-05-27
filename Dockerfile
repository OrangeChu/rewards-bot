FROM mcr.microsoft.com/playwright:v1.44.1-jammy

WORKDIR /usr/src/microsoft-rewards-script

COPY . .

RUN npm install

RUN npm run build

# Install cron
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y cron python3 python3-pip tzdata && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install croniter

RUN npx playwright install chromium

# Give execution rights to run_daily.sh
RUN chmod +x /usr/src/microsoft-rewards-script/src/run_daily.sh

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Copy the entrypoint script
COPY entrypoint.sh /usr/src/microsoft-rewards-script/entrypoint.sh
RUN chmod +x /usr/src/microsoft-rewards-script/entrypoint.sh

# Run the entrypoint script on container startup
CMD /bin/bash /usr/src/microsoft-rewards-script/entrypoint.sh
