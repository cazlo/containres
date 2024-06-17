# Containres Documentation

This folder is intended to be rendered as the docs_dir by mkdocs.

The global Makefile located at project root has runtime scripts to facilitate running all of this in docker locally:
- `make build-docs` = build container image with all the necessary document generation tools installed
- `make run-docs` = starts a document generation container image session with a interactive shell. ctrl+D to exit.
- `make run-docs-live-reload` = starts the dev server to serve artifacts live. ctrl+C to exit.

The rebuild of the container image, has been optimized to re-use cache as often as possible.
The typical dev workflow is `make build-docs run-docs-live-reload`