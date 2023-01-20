.DEFAULT_GOAL := help
.PHONY: help
help: ## ℹ️ Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


deps: ## 🛠  Install deps needed for the job to run
	@ansible-galaxy install tarantool.cartridge,1.12.0

deploy-test: ## 🧪 Deploy the test environment
	@ansible-playbook -i testnet.yaml playbook.prepare.yml --limit router_rs,s_1 --vault-password-file=.zenflows-storage-vault
