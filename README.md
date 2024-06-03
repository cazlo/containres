# containres
AWS RES but more containerized

Fork of https://github.com/aws/res/releases/tag/2024.04.02

Replace CDK as much as possible with terraform

## Why

RES is a really nice foundation but it has a few challenges w.r.t. it's current architecture:
- CDK for managing raw EC2s has some drawbacks, including sometimes non-deterministic update and rollback scenarios, and relatively long deploy times
- There are 4 microservices, and effectively each gets its own EC2, but they are very low resource consumption so could realisitcally stack onto 1 box in most scales
  - Each EC2 takes at least 15 minutes to rollout for update use case. One of them takes 25 minutes for update use case
- Not everything can be changed through IaC/a cdk deploy command.
  - Cluster settings pretty much need to be manually edited in table directly, no way to update them found via cdk deploy
  - VDI host template changes require re-deploy of virtual-desktop-controller stack, at least 25 minutes of time in current cdk pipeline
- There is no good way to do an actual plan of the IaC before running it with current cdk deploy.  This is mostly because the current cdk deploy is really just an installer which abstracts interactions with like 7 or so other cdk stacks.  These "child" stacks are not included in cdk diff commands surfaced so far

## Migration process

The remote RES repo was initially bootstrapped with

```shell
git subtree add --prefix res https://github.com/aws/res.git 2024.04.02
```

Poetry was arbitrarily used as the dependency management framework, mostly because of author bias and familiarity with the tool.

The initial idea is to effectively split out the many disparate pip environments, and combine them into a single poetry module called `containres`.

This should simplify testing and dependency management for deployments, (for example we have to maintain only 1 pip env and dependency list instead of 9 inter-connected dependency lists and all the associated code around assembling them).

Additionally, it should facilitate rapid turnaround integration testing in a unit test like environment using pytest. Running like this, we can more easily developer coverage reports for cross-micro-service test coverage measurement.

The various sub-modules under `res/idea` will be extracted into `containres`.

The implication of this folder re-org is primarily imports have to change.
For example, an import like "from ideasdk.api import ApiInvocationContext" changes to "from containres.ideasdk.api import ApiInvocationContext"

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


