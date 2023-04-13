FROM python:3.11-slim
ENV PIP_NO_CACHE_DIR=yes
WORKDIR /app
COPY scripts/ /app
COPY requirements.txt /app

RUN pip install -r requirements.txt

CMD ["python", "main.py"]
