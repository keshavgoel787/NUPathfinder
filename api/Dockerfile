FROM python:3.11-slim

WORKDIR /apicode

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

RUN pip install mysql-connector-python


COPY . .

EXPOSE 4000

CMD [ "python", "backend_app.py"]

