# Stage 1: Build
FROM node:18 AS web-build

# Set working directory
WORKDIR /opt/idea/app

# Install dependencies
COPY webapp/package.json webapp/yarn.lock ./
RUN yarn install

# Copy the rest of the application
COPY webapp/. .

# Build the application
RUN yarn run build


# Use the official Python image with the exact version you need
FROM python:3.9.19-slim as py-build
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
RUN apt-get update && apt-get install -y build-essential ldap-utils libldap2-dev libsasl2-dev uuid jq && rm -rf /var/lib/apt/lists/*
# install deps for healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

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

COPY infra/cluster-config-setup.sh /opt/idea/app/cluster-config-setup.sh
RUN chmod +x /opt/idea/app/cluster-config-setup.sh
COPY infra/run-python-backend-app.sh /opt/idea/app/run-python-backend-app.sh
RUN chmod +x /opt/idea/app/run-python-backend-app.sh
RUN mkdir -p /internal/res-dev/certs
RUN chown appuser:appuser /internal/res-dev/certs

RUN chown appuser:appuser /run

# Switch to the non-root user
USER appuser

# Install the application itself
RUN poetry install
# todo should really copy to a layer which does not have big build-only deps like gcc (build-essential)

RUN mkdir /opt/idea/app/logs

# Copy build output to Nginx
COPY --from=web-build /opt/idea/app/build /opt/idea/app/containres/deploy/cluster-manager/webapp

# Set the locale environment variables which RES is tested against/uses in ops
ENV LC_ALL C.UTF-8
ENV LC_CTYPE=C.UTF-8
CMD ["poetry", "run", "python", "-m", "containres.ideaclustermanager.app.app_main"]

HEALTHCHECK --interval=5s --timeout=10s --start-period=1s --retries=30 CMD curl --insecure --fail https://127.0.0.1:8443/healthcheck || exit 1