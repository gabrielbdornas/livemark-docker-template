FROM python:3.9.12-slim-bullseye
RUN apt-get -y update
RUN apt-get -y install build-essential
RUN apt-get -y install git
WORKDIR /work_dir
COPY requirements.txt /
RUN pip install -r /requirements.txt
