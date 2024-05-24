FROM mcr.microsoft.com/playwright:v1.44.1-jammy

WORKDIR /usr/src/app

COPY . .

RUN npm install
RUN npx playwright install
RUN npm run build

# Install cron
RUN apt-get update && apt-get install -y cron bc

# Give execution rights to run_daily.sh
RUN chmod +x /usr/src/app/src/run_daily.sh

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Copy the entrypoint script
COPY entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# Run the entrypoint script on container startup
CMD /usr/src/app/entrypoint.sh
