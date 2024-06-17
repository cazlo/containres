---
# These are optional elements. Feel free to remove any of them.
adr: true
status: accepted
#base_for: 
# - "decisions/adr-template.html"
date: 2024-05-31
decision-makers: 
 - "@cazlo (Drew Paettie)"

tags:
 - vision
 - deployment
---

# 0001 Migrate RES Backend Services to Containerized Deployment

## Context and Problem Statement

RES is a really nice foundation for managed VDI, but it has a few challenges in it's current architecture:

- CDK for managing raw EC2s has some drawbacks, including sometimes non-deterministic update and rollback scenarios, and relatively long deploy times
- There are 4 microservices, and effectively each gets its own EC2, but they are very low resource consumption so could realisitcally stack onto 1 box in most scales
    - Each EC2 takes at least 15 minutes to rollout for update use case. One of them takes 25 minutes for update use case
- Not everything can be changed through IaC/a cdk deploy command.
    - Cluster settings pretty much need to be manually edited in table directly, no way to update them found via cdk deploy
    - VDI host template changes require re-deploy of virtual-desktop-controller stack, at least 25 minutes of time in current cdk pipeline
- There is no good way to do an actual plan of the IaC before running it with current cdk deploy.  This is mostly because the current cdk deploy is really just an installer which abstracts interactions with like 7 or so other cdk stacks.  These "child" stacks are not included in cdk diff commands surfaced so far

How can we optimize the management of the existing python business logic which defines RES, while minimizing the risk of introducing fault during the refactors?

## Decision Drivers

- Time to make a change and get end to end test feedback should be minified.
- Automated test coverage should be maximized.
- All infrastructure configuration should be defined as code and testable locally as much as possible.

## Considered Options

- Maintain "On-Demand Bootstrapping" deployment mechanism maintained through RES CDK installer process.
- Migrate to "Pre-Packaged AMI Deployment" deployment mechanism maintained through slightly modified RES CDK installer process or some other more-indepth refactor.
- Migrate to "Containerized backend services" deployment mechanism

## Decision Outcome

Chosen option: "Containerized backend services", because it allows for an isolated and atomic deployment architecture which can be nearly fully tested locally, facilitating high test coverage and parallelization.

## More Information

### Container Migration Process

The remote RES repo was initially bootstrapped with
```shell
git subtree add --prefix res https://github.com/aws/res.git 2024.04.02
```
Through use of git subtree, we import the project git history to provide appropriate accreditation of the remote code, as well as reproduction of the existing software license.
Additionally, we can later pull in changes through commands like `git subtree pull`, so we can pull in upstream changes later in a way which automatically merges in-place changes in this repo with upstream changes.

The python dependency management in this version of RES is fairly complicated, with 9 distinct, but interconnected pip dependency trees used for the various contexts.
`pyproject.toml` was not used for dependency locking at the app/context level, but rather a [pip-tools](https://github.com/jazzband/pip-tools) based dependency locking mechanism.
The dependency assembly was largely orchestrated by a click driven python CLI which required a subset of those tools to be present on the machine before the python dependency assembly could proceed.
This dependency management meant things like importing the project into an IDE such as VSCode or PyCharm was not possible without somewhat extensive setup and/or host level configuration. 

In an attempt to simplify and codify the project dependency management, poetry was arbitrarily used as the dependency management framework, mostly because of author bias and familiarity with the tool.
The initial idea is to effectively split out the many disparate pip environments, and combine them into a single poetry module called `containres`.
This should simplify testing and dependency management for deployments, (for example we have to maintain only 1 pip env and dependency list instead of 9 inter-connected dependency lists and all the associated code around assembling them).
Additionally, it should facilitate rapid turnaround integration testing in a unit test like environment using pytest. Running like this, we can more easily developer coverage reports for cross-micro-service test coverage measurement.

The various sub-modules under `res/idea` will be extracted into a common `containres` folder/python module.
The implication of this folder re-org is primarily imports have to change.
For example, an import like 
```python
from ideasdk.api import ApiInvocationContext
```
 changes to 
```python 
from containres.ideasdk.api import ApiInvocationContext
```

A script was re-written to convert from the pip-tools based dependency locking framework RES was using to poetry dependency locking/mgmt.  Example test runs:

```shell
./res/requirements/poetry-add.sh res/requirements/idea-sdk.txt
./res/requirements/poetry-add.sh res/requirements/tests.in --dev
```

Migrating this way required a few manual changes, for example sanic is missing from some of the files analyzed, and had to be manually added with:
```shell
poetry add sanic==23.12.1
poetry add sanic-ext==23.12.0
poetry add sanic-routing==23.12.0
```

It is possible to get all of the dependencies imported in with a script like `./res/requirements/poetry-add.sh res/requirements/dev.txt`, however during the import git commits are made with each new package import, to hopefully make it easier to see what all microservices are really using what all dependencies.


