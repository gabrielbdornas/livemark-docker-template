.PHONY: help image container build start

MD_FILES= $(wildcard pages/*.md)
HTML_FILES= $(patsubst pages/%.md, pages/%.html, $(MD_FILES))

help: ## Short description of the commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

image: ## Build Docker Image
	@echo 'Building Docker Image...'
	@docker build . --no-cache --file Dockerfile --tag livemark-webserver

container: ## Start Docker Container
	@echo 'Starting Docker Container...'
	@docker run -it -v /$(PWD):/work_dir -p 7000:7000 livemark-webserver bash

index.html: index.md
	@echo 'Building index.html file from index.md...'
	@livemark build $< --target $@ --config livemark.yaml

build: $(HTML_FILES) ## Run livemark build inside pages folder

$(HTML_FILES): pages/%.html : pages/%.md index.html
	@echo 'Building pages/$*.html file from pages/$*.md...'
	@livemark build $< --target $@ --config livemark.yaml

start: ## Start livemark server
	@echo 'Starting livemark server on localhost:7000...'
	@livemark start --host=0.0.0.0
