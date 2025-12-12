FROM python:3.12-slim-trixie

LABEL maintainer="fleureed@gmail.com"
WORKDIR /app
RUN apt-get update && \
    apt-get upgrade -y
COPY requirements.txt requirements.txt
RUN /usr/local/bin/pip install \
  --root-user-action=ignore \
  --disable-pip-version-check \
  -r requirements.txt
COPY src/* /app/
USER nobody
ENTRYPOINT ["/app/main.py", "--config_file=config/config.yaml"]
