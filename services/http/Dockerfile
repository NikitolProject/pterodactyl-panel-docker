FROM docker.io/library/nginx:alpine

LABEL maintainer="tehtotalpwnage@gmail.com"

RUN adduser -g '' -D -u 9999 pterodactyl

COPY nginx.conf /etc/nginx/nginx.conf
