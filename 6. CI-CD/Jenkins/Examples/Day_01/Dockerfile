# Use an official Python runtime as a parent image
FROM python:3.10-slim-buster

RUN apt update -y && apt install awscli -y
RUN apt-get install -y git

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --upgrade pip
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install streamlit

# Expose port 8501 for streamlit
EXPOSE 8501

# Define environment variable for streamlit
ENV STREAMLIT_SERVER_HEADLESS=true
ENV STREAMLIT_SERVER_PORT=8501

# Run streamlit app
CMD ["streamlit", "run", "app.py"]