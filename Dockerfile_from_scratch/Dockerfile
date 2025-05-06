# Stage 1: Builder
FROM golang:1.21 AS builder

WORKDIR /app
COPY main.go .

# Create module inside container
RUN go mod init flight-distance

# Build statically linked binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o app

# Stage 2: Minimal runtime image
FROM scratch
COPY --from=builder /app/app /
EXPOSE 8080
CMD ["/app"]
