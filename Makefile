# Makefile for Nix development in Docker, with formatting targets

COMPOSE   := docker compose        # works whether you alias `docker-compose` or not
SERVICE   := dev

# Declare phony targets so Make doesn't confuse them with files
.PHONY: up shell nix build rebuild stop clean gc help fmt-nix fmt-nixpkgs fmt-all

# ---- docker compose

## Bring the dev environment up (detached)
up:
	$(COMPOSE) up -d

## Rebuild the container after changing compose/Nix files
rebuild:
	$(COMPOSE) up -d --build --force-recreate

## Stop containers, retaining volumes
stop:
	$(COMPOSE) down

## Stop containers *and* wipe named volumes (nix_store)
clean:
	$(COMPOSE) down -v --remove-orphans

## Prune dangling images/containers on the host
gc:
	docker system prune -f

# ---- nix

## Drop into a bash shell inside the dev container
shell: up
	$(COMPOSE) exec $(SERVICE) bash

## Enter a Nix develop shell (flake‑aware) with formatters loaded
nix: up
	$(COMPOSE) exec $(SERVICE) nix develop --command bash

## Format nix files
fmt: up
	$(COMPOSE) exec $(SERVICE) sh -c "nix-shell -p nixpkgs-fmt --run 'nixpkgs-fmt **/*.nix'"
	$(COMPOSE) exec $(SERVICE) sh -c "nix-shell -p alejandra --run 'alejandra .'"

## Build any flake outputs inside the container
build: up
	$(COMPOSE) exec $(SERVICE) nix build

build-turmeric: up
	$(COMPOSE) exec $(SERVICE) sh -c "SKIP_SANITY_CHECKS=1 nix-shell -p home-manager --command 'home-manager switch --flake /workspace#turmeric'"

## Show this help
help:
	@grep -E '^[A-Za-z_-]+:.*?##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-12s\033[0m%s\n", $$1, $$2}'
