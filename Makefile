# do nothing.
.PHONY: all
all:


# run a development server
.PHONY: server-dev
server-dev:
	hugo server --buildDrafts


# run a server
.PHONY: server
server:
	hugo server


# build web site
.PHONY: build
build:
	hugo


# remove public directory
.PHONY: clean
clean:
	rm -r public/
