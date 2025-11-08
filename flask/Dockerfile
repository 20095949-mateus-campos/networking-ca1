# Module Title:         Network Systems and Administration
# Module Code:          B9IS121
# Module Instructor:    Kingsley Ibomo
# Assessment Title:     Automated Container Deployment and Administration in the Cloud
# Assessment Number:    1
# Assessment Type:      Practical
# Assessment Weighting: 60%
# Assessment Due Date:  Sunday, 9 November 2025, 8:36 AM
# Student Name:         Mateus Fonseca Campos
# Student ID:           20095949
# Student Email:        20095949@mydbs.ie
# GitHub Repo:          https://github.com/20095949-mateus-campos/networking-ca1

# This file belongs to Part 3: Docker Container Deployment

# syntax=docker/dockerfile:1

# runs Ubuntu 22.04 inside the container
FROM ubuntu:22.04

# install python and pip
RUN apt-get update && apt-get install -y python3 python3-pip

# copy local requirements.txt to the container
COPY requirements.txt /

# install all app dependencies
RUN pip install -r requirements.txt

# copy main app file to the container
COPY app.py /

# runs app on container port 8000
EXPOSE 8000

# maps to port 8000 on the host (unrestricted host address)
# using Gunicorn to WSGI-HTTP bridge Python/Flask and Nginx
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "app:app"]
