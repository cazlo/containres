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

## System Architecture Documentation

See [the docs folder](./docs/README.md).