# do nothing.
.PHONY: all
all:


# create a new article for trip and photo
# e.g.)
# 	make article KIND=trip SLUG=2025-01-01-trip-some-place
.PHONY: article
article:
	@case "$(KIND)" in \
		trip|tripphoto|camping) ;; \
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
