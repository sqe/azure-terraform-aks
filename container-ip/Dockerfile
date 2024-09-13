FROM python:3.11

RUN mkdir /container_ip
COPY source/ container_ip/
WORKDIR /container_ip

RUN pip install --upgrade pip
RUN pip3 install -r requirements.txt
ARG GIT_VERSION="v0.0.1"
ENV PORT 80
ENV GIT_VERSION=$GIT_VERSION
EXPOSE 80
ENV FLASK_APP=container_ip.py
ENTRYPOINT [ "flask", "run", "--host=0.0.0.0", "--port=80" ]
