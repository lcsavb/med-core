from nginx:alpine

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY static /usr/share/nginx/html
RUN mv /usr/share/nginx/html/scripts /usr/share/nginx/scripts
RUN mv /usr/share/nginx/html/styles /usr/share/nginx/styles

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]