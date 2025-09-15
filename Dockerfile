FROM golang:1.24.26-bullseye AS builder
WORKDIR /app

# Cache dependencies
COPY go.mod ./
RUN go mod download

# Build the application
COPY . .

# Build for Linux with CGO disabled
ENV CGO_ENABLED=0
RUN GOOS=linux GOARCH=amd64 \ 
    go build -v -o gitops -ldflags="-w -s"

# Use a minimal base image for the final stage
FROM gcr.io/distroless/static-debian12:nonroot
WORKDIR /app
LABEL maintaner="Marcos Cianci <marcos.cianci@gmail.com>"
COPY --from=builder /app/gitops /app/gitops
EXPOSE 8282
USER nonroot:nonroot
ENTRYPOINT ["/app/gitops"]
