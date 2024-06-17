# Use the official Python image with the exact version you need
FROM python:3.9.19-slim
ENV DEBIAN_FRONTEND noninteractive

# os patch
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
# install deps for python-ldap
RUN apt-get update && apt-get install -y build-essential ldap-utils libldap2-dev libsasl2-dev uuid jq && rm -rf /var/lib/apt/lists/*
# install deps for dynamodb local
RUN apt-get update && apt-get install -y default-jre-headless && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group
RUN groupadd -r appuser && useradd -m -r -g appuser appuser

# Set the working directory in the container
WORKDIR /opt/idea/app

# Install Poetry
RUN pip install poetry
# Install third party dependencies before copying source code for faster local rebuilds
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false && \
 poetry install --no-root

# Copy the rest of the application code to the container
COPY --chown=appuser:appuser README.md /opt/idea/app/
COPY --chown=appuser:appuser containres /opt/idea/app/containres
COPY --chown=appuser:appuser tests /opt/idea/app/tests
# Install the application itself
RUN poetry config virtualenvs.create false && \
 poetry install

# Change ownership of the application directory to the non-root user
RUN chown -R appuser:appuser /opt/idea/app
# Switch to the non-root user
USER appuser
RUN poetry config virtualenvs.create false
# Generate the desired locale
#RUN locale-gen en_US.UTF-8

# Set the locale environment variables which RES is tested against/uses in ops
ENV LC_ALL C.UTF-8
ENV LC_CTYPE=C.UTF-8
# Specify the entry point for the container to run tests
ENTRYPOINT ["poetry", "run", "pytest", "--cov"]

