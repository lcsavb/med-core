FROM nginx:alpine

# Copy configuration and static files
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY static /usr/share/nginx/html
RUN mv /usr/share/nginx/html/scripts /usr/share/nginx/scripts
RUN mv /usr/share/nginx/html/styles /usr/share/nginx/styles

# Install inotify-tools using Alpine's apk package manager
RUN apk update && apk add inotify-tools

# Copy the entrypoint script
COPY nginx-stacy-entrypoint.sh /usr/bin/nginx-stacy-entrypoint.sh
RUN chmod +x /usr/bin/nginx-stacy-entrypoint.sh

# Expose the web server port
EXPOSE 80

# Run the entrypoint script
CMD ["/usr/bin/nginx-stacy-entrypoint.sh"]


