FROM golang:1.19-bullseye AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o gitops -ldflags="-w -s"

FROM gcr.io/distroless/static:nonroot
WORKDIR /app
LABEL maintaner="Marcos Cianci <marcos.cianci@gmail.com>"
COPY --from=builder /app/gitops /app/gitops
EXPOSE 8282
USER nonroot:nonroot
ENTRYPOINT ["/app/gitops"]
