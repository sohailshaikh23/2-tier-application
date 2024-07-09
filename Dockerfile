#For best practice use slim base image
FROM python:3.9-slim   


# Set the working directory 
WORKDIR /app

# install required packages and required libraries files
# For best practice use minimum run command to minimum layer
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \    #library files and mysqlclient require to connect with mysql
    && rm -rf /var/lib/apt/lists/*      

# Copy the requirements file into the container
COPY requirements.txt .

# Installing dependencies for mysql client
RUN pip install mysqlclient
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application source code 
COPY . .

#  Run your application 
ENTRYPOINT ["python"]
CMD ["app.py"]

