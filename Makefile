Arguments := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

domain:
	mkdir $(Arguments) & \
	TERRAGRUNT_AUTO_INIT=false TG_business_domain=$(Arguments) terragrunt plan --terragrunt-no-auto-init & \
	make workflow $(Arguments) & \
	make tf-linter & \
	make yaml-linter
workflow:
	docker container run --rm -v $(PWD):/app mikefarah/yq -i '.on.workflow_dispatch.inputs.domains.options += ["$(Arguments)"]' /app/.github/workflows/deploy_flow.yaml
tf-linter:
	docker container run --rm -i -v $(PWD):/app -w /app --entrypoint "" ghcr.io/terraform-linters/tflint:v0.46.1 tflint --recursive
yaml-linter:
	docker container run --rm -i -v $(PWD):/app -w /app --entrypoint "" cytopia/yamllint:alpine-1 yamllint .
json-linter:
	find . -name \*.json  | xargs -I {} docker container run --rm -i -v $(PWD):/app -w /app --entrypoint "" cytopia/jsonlint:alpine-1.6.0 jsonlint -t '  ' -q {}

markdown-linter:
	docker container run --rm -i -v $(PWD):/app -w /app --entrypoint "" markdownlint/markdownlint:0.12.0 mdl .
%::
	@true