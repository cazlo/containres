# Welcome to MkDocs

For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

```mermaid
graph LR
  dcv-broker
  dcv-gateway
  config-bootstrapper --> cluster-manager
  config-bootstrapper --> virtual-desktop-controller

  subgraph Emulated-AWS-Resources
    localstack --> terraform
    terraform -. Creates .-> config-db[(Config DB)]
    terraform -. Creates .-> config-secrets[(Config Secrets DB)]
    terraform -. Creates .-> sqs[/Task Queues/]
    terraform --> config-bootstrapper -. WritesTo .-> config-db

  end

```

```plantuml

@startuml C4_Elements
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Container.puml

Person(personAlias, "Label", "Optional Description")
Container(containerAlias, "Label", "Technology", "Optional Description")
System(systemAlias, "Label", "Optional Description")

Rel(personAlias, containerAlias, "Label", "Optional Technology")
@enduml
```