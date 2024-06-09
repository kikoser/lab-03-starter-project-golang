FROM golang:1.16 AS builder

WORKDIR /app

COPY go.mod go.sum .

RUN go mod download

COPY cmd ./cmd
COPY lib ./lib
COPY templates ./templates
COPY main.go .

RUN CGO_ENABLED=0 go build -o ./myapp
FROM gcr.io/distroless/static-debian11

COPY --from=builder /app/myapp /myapp
COPY templates /templates

CMD ["./myapp", "serve"]
