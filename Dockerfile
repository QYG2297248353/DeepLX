# syntax=docker/dockerfile:1

FROM golang:1.22 AS builder
WORKDIR /go/src/github.com/OwO-Network/DeepLX
COPY main.go ./
COPY types.go ./
COPY utils.go ./
COPY config.go ./
COPY translate.go ./
COPY go.mod ./
COPY go.sum ./
RUN go get -d -v ./
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o deeplx .

FROM alpine:latest

ENV TZ Asia/Shanghai
RUN apk add --no-cache tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \

EXPOSE 1188

WORKDIR /app
COPY --from=builder /go/src/github.com/OwO-Network/DeepLX/deeplx /app/deeplx
CMD ["/app/deeplx"]
