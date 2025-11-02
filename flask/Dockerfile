# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# install app dependencies
RUN apt-get update && apt-get install -y python3 python3-pip

COPY requirements.txt /

RUN pip install -r requirements.txt

# install app
COPY app.py /

# final configuration
EXPOSE 8000
# CMD ["flask", "run", "--host", "0.0.0.0", "--port", "8000"]
CMD ["gunicorn", "--bind", "localhost:8000", "--workers", "4", "app:app"]
# CMD ["gunicorn", "--workers", "4", "app:app"]
