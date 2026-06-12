FROM hr.12w.ir/d/library/golang:1.22-alpine AS builder
WORKDIR /app

RUN apk add -U --no-cache ca-certificates

ENV GOPROXY=https://goproxy.cn,direct

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o server main.go

FROM scratch
WORKDIR /app

COPY --from=builder /app/server .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 3000

ENTRYPOINT ["/app/server"]