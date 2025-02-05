FROM golang:1.23.4-alpine as builder
RUN apk update && apk upgrade && \
    apk add --no-cache git curl
RUN git clone https://github.com/donserdal/smtp2discord /go/src/build
WORKDIR /go/src/build
RUN go mod vendor
ENV CGO_ENABLED=0
RUN GOOS=linux go build -mod vendor -a -o smtp2discord .

FROM golang:1.23.4-alpine
WORKDIR /root/
COPY --from=builder /go/src/build/smtp2discord /usr/bin/smtp2discord
ENTRYPOINT ["smtp2discord"]
