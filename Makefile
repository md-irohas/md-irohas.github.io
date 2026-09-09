.DEFAULT_GOAL := help


# show available targets and variables
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make <target> [VARIABLE=value]"
	@echo
	@echo "Targets:"
	@echo "  help          Show this help"
	@echo "  article       Create English and Japanese blog articles"
	@echo "  tech-article  Create English and Japanese tech articles"
	@echo "  server        Run a local server"
	@echo "  server-dev    Run a local server with drafts"
	@echo "  build         Build the production site"
	@echo "  build-dev     Build the development site"
	@echo "  clean         Remove the generated public directory"
	@echo
	@echo "Variables:"
	@echo "  KIND          Blog article kind: travel, photo, camping"
	@echo "  SLUG          Article slug"
	@echo
	@echo "Examples:"
	@echo "  make article KIND=travel SLUG=2026-01-01-travel-some-place"
	@echo "  make tech-article SLUG=2026-01-01-some-slug"


# do nothing.
.PHONY: all
all:


# create a new article for travel and photo
# e.g.)
# 	make article KIND=travel SLUG=2025-01-01-travel-some-place
.PHONY: article
article:
	@case "$(KIND)" in \
		travel|photo|camping|trip|tripphoto) ;; \
		*) echo "invalid kind: $(KIND)"; exit 1;; \
	esac
	@if [ -z "$(SLUG)" ]; then \
		echo "empty slug."; exit 1; \
	fi

	hugo new content -k "$(KIND).en" blog/$(SLUG)/index.en.md
	hugo new content -k "$(KIND).ja" blog/$(SLUG)/index.ja.md


# create new article for tech
# e.g.)
# 	make tech-article SLUG=2025-01-01-some-slug
.PHONY: tech-article
tech-article:
	@if [ -z "$(SLUG)" ]; then \
		echo "empty slug."; exit 1; \
	fi
	hugo new content -k "tech.en" tech/$(SLUG)/index.en.md
	hugo new content -k "tech.ja" tech/$(SLUG)/index.ja.md


# run a server
.PHONY: server
server:
	hugo server


# run a development server
.PHONY: server-dev
server-dev:
	hugo server --buildDrafts


# build web site
.PHONY: build
build:
	hugo build --environment=production


# build web site in development mode
.PHONY: build-dev
build-dev:
	hugo build --environment=development


# remove public directory
.PHONY: clean
clean:
	rm -r public/
