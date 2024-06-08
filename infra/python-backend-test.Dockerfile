# Use the official Python image with the exact version you need
FROM python:3.9.19-slim
ENV DEBIAN_FRONTEND noninteractive

# os patch
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group
RUN groupadd -r appuser && useradd -m -r -g appuser appuser

# Set the working directory in the container
WORKDIR /opt/idea/app

# Install Poetry
RUN pip install poetry

# install deps for python-ldap
RUN apt-get update && apt-get install -y build-essential ldap-utils libldap2-dev libsasl2-dev&& rm -rf /var/lib/apt/lists/*
# install deps for dynamodb local
RUN apt-get update && apt-get install -y default-jre-headless && rm -rf /var/lib/apt/lists/*

# Copy the pyproject.toml and poetry.lock files to the container
COPY pyproject.toml poetry.lock ./

# Install dependencies using Poetry
RUN poetry install --no-root

# Copy the rest of the application code to the container
COPY README.md README.md
COPY containres containres
COPY tests tests

# Change ownership of the application directory to the non-root user
RUN chown -R appuser:appuser /opt/idea/app

# Switch to the non-root user
USER appuser

# Install the application itself
RUN poetry install


# Generate the desired locale
#RUN locale-gen en_US.UTF-8

# Set the locale environment variables which RES is tested against/uses in ops
ENV LC_ALL C.UTF-8
ENV LC_CTYPE=C.UTF-8
# Specify the entry point for the container to run tests
ENTRYPOINT ["poetry", "run", "pytest", "--cov"]

