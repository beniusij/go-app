# Go related commands
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get -u -v
APP_NAME=go-app

# Docker build image from Dockerfile
.PHONY: build
build:
	docker build -t $(APP_NAME) .

# Start docker container and run a command
.PHONY: up
up:
	docker run -d -p 8080:8080 --name="$(APP_NAME)" $(APP_NAME)

# Stops and removes container
.PHONY: stop
stop:
	docker stop $(APP_NAME); docker rm $(APP_NAME)

# Runs unit tests.
.PHONY: test
test:
	$(GOTEST)