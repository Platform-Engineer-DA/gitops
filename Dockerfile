FROM golang:1.19-buster AS builder

WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -v -o gitops -ldflags="-w -s"

FROM debian:buster-slim
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*
LABEL maintaner="Marcos Cianci <marcos.cianci@gmail.com>"
COPY . .
COPY --from=builder /app/gitops /app/gitops
EXPOSE 8282
ENTRYPOINT ["/app/gitops"]
