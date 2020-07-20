FROM nginx:1.15.8

ENV RAILS_ROOT /var/www/ror_app

WORKDIR ${RAILS_ROOT}

RUN rm /etc/nginx/nginx.conf

COPY ./deploy/nginx/nginx.conf /etc/nginx/

RUN rm /etc/nginx/conf.d/default.conf

COPY ./public public

COPY ./deploy/nginx/app.conf /tmp/temp.conf

RUN envsubst '$RAILS_ROOT' < /tmp/temp.conf > /etc/nginx/conf.d/app.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]