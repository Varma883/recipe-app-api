# Use the official Python 3.12 slim image as the base
FROM python:3.12-slim

# Add metadata about who maintains this image (optional)
LABEL maintainer="Tanishka Varma"

# Makes python output printed directly (not buffered)
ENV PYTHONUNBUFFERED 1

# Copy the requirements file into the container temporary folder
COPY ./requirements.txt /tmp/requirements.txt

COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy your application code into /app inside the container
COPY ./app /app

# Set working directory to /app (all commands run from here)
WORKDIR /app

# Expose port 8000 so external world can access Django server
EXPOSE 8000


ARG DEV=false
# Create a Python virtual environment inside container at /py
# Upgrade pip, install dependencies, clean temp files
# and create a new user called django-user
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Add our new virtual environment to the PATH
ENV PATH="/py/bin:$PATH"

# Switch the user from root to django-user for security
USER django-user
