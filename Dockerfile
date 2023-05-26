FROM ubuntu:18.04 AS flutter-builder

RUN apt-get update && \
    apt-get install -y git wget curl unzip libglu1

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter channel beta
RUN flutter upgrade
RUN flutter config --enable-web

WORKDIR /app
COPY . .
RUN flutter build web

FROM nginx
#RUN apt-get update && \
#    apt-get install -y nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=flutter-builder /app/build/web /var/www/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
