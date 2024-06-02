# Use the official Python image with the exact version you need
FROM python:3.9.19-slim
ENV DEBIAN_FRONTEND noninteractive

# os patch
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group
RUN groupadd -r appuser && useradd -m -r -g appuser appuser

# Set the working directory in the container
WORKDIR /app

# Install Poetry
RUN pip install poetry

# install deps for python-ldap
RUN apt-get update && apt-get install -y build-essential ldap-utils libldap2-dev libsasl2-dev&& rm -rf /var/lib/apt/lists/*

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
# todo should really copy to a layer which does not have big build-only deps like gcc (build-essential)

# Set the locale environment variables which RES is tested against/uses in ops
ENV LC_ALL C.UTF-8
ENV LC_CTYPE=C.UTF-8
# todo nothing runs in app land yet
CMD ["poetry", "run", "python", "-m", "your_project.main"]
