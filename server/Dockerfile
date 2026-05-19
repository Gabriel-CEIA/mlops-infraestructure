FROM python:3.12-alpine

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir release

COPY *.py .

EXPOSE 8000

CMD [ "sh", "-c", "fastapi run app.py & python worker.py" ]

