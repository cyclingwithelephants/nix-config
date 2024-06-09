bootstrap:
	nix run nix-darwin -- switch --flake .#garlic

build:
	darwin-rebuild switch --flake .#garlic

update:
	nix flake update --commit-lock-file

build-from-remote:
	nix run nix-darwin -- --flake github:cyclingwithelephants/nix-config#garlic
