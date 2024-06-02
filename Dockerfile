# Use the official Python image with the exact version you need
FROM python:3.9.19-slim
ENV DEBIAN_FRONTEND noninteractive

# os patch
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
# Install required packages for locale configuration
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/*

# Generate and set locale
RUN dpkg-reconfigure locales

# Create a non-root user and group
RUN groupadd -r appuser && useradd -m -r -g appuser appuser

# Set the working directory in the container
WORKDIR /app

# Install Poetry
RUN pip install poetry

# Ensure Poetry is in the PATH
#ENV PATH="/root/.local/bin:${PATH}"

# Copy the pyproject.toml and poetry.lock files to the container
COPY pyproject.toml poetry.lock ./

# Install dependencies using Poetry
RUN poetry install --no-root

# Copy the rest of the application code to the container
COPY README.md README.md
COPY containres containres
COPY tests tests

# Change ownership of the application directory to the non-root user
RUN chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Install the application itself
RUN poetry install
# Set the locale environment variables which RES is tested against/uses in ops
ENV LC_ALL C.UTF-8
ENV LC_CTYPE=C.UTF-8
# todo nothing runs in app land yet
CMD ["poetry", "run", "python", "-m", "your_project.main"]
