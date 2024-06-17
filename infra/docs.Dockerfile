FROM python:3.9.19-slim as py-build

ENV DEBIAN_FRONTEND noninteractive

# os patch
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*


# setup mkdocs
RUN pip install mkdocs

WORKDIR /opt/app

# Install PlantUML Markdown and all Dependencies for local build of images
RUN pip install plantuml-markdown
RUN apt-get update && \
    apt-get install -y openjdk-17-jre-headless graphviz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV PLANTUML_JAVAOPTS="-Djava.awt.headless=true"
ADD https://github.com/plantuml/plantuml/releases/download/v1.2024.5/plantuml-1.2024.5.jar /opt/plantuml/plantuml.jar
RUN echo "#!/bin/bash" > /usr/local/bin/plantuml && \
    echo 'java $PLANTUML_JAVAOPTS -jar /opt/plantuml/plantuml.jar ${@}' >> /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

# Install mermaid2 plugin
RUN pip install mkdocs-mermaid2-plugin
# todo install

# Install MkDocs as dependency for proper pallete-specific diagram color rendering + nicer ubjectively CSS overall
RUN pip install mkdocs-material

# todo this also looks useful for easier PDF generation
#RUN pip install mkdocs-print-site-plugin

COPY mkdocs.yml .
COPY adr_theme adr_theme