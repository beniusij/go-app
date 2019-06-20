#########################################
# Step 1: Build executable binary
#########################################

# FROM golang:alpine AS builder

FROM golang@sha256:cee6f4b901543e8e3f20da3a4f7caac6ea643fd5a46201c3c2387183a332d989 AS builder

# Install git + SSL ca certificates
RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates

# Create appuser
RUN adduser -D -g '' appuser

WORKDIR $GOPATH/src/mypackages/go-app/
COPY . .

# Fetch dependencies

# Using go get
RUN go get -d -v 

# Using go mod
# RUN go mod download
# RUN go mod verify

# Build binary
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/backoffice

#########################################
# Step 2: Build a small image
#########################################

FROM scratch

# Import from the builder
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd

# Copy statis executable
COPY --from=builder go/bin/backoffice go/bin/hello

# Use an unpriviledged user
USER appuser

# Port on which the service will be exposed
EXPOSE 9292

# Run the hello binary
ENTRYPOINT ["/go/bin/hello"]