#!/bin/sh

# Start nginx in the background
nginx -g 'daemon off;' &

# Monitor for changes and reload nginx when files are modified
while inotifywait -e modify /usr/share/nginx/html /etc/nginx/nginx.conf; do
    nginx -s reload
done
