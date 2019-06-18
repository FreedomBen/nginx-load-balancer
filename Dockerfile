FROM fedora:30

RUN dnf install -y vim git nginx elixir erlang

ENV TLS_KEY_LENGTH=2048
RUN mkdir -p /etc/pki/nginx/private \
 && openssl req -new -newkey rsa:${TLS_KEY_LENGTH} -days 3650 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=server/CN=server.dev" \
    -keyout /etc/pki/nginx/private/server.key  -out /etc/pki/nginx/server.crt \
 && openssl dhparam -out /etc/pki/nginx/private/dhparam.pem ${TLS_KEY_LENGTH}

RUN mkdir /app
WORKDIR /app

COPY sample_app /app/
RUN mix local.hex --force

COPY nginx-https.conf /etc/nginx/nginx.conf

CMD /bin/bash
