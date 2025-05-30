# do nothing.
.PHONY: all
all:


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
