FROM golang:alpine AS builder

ENV GO111MODULE=on  \
    CGO_ENABLED=0   \
    GOOS=linux      \
    GOARCH=amd64

# build 디렉토리에서 작업
WORKDIR /build

COPY go.mod go.sum main/main.go ./

RUN go mod download

RUN go build -o main .

WORKDIR /dist

RUN cp /build/main .

FROM scratch

COPY --from=builder /dist/main .

ENTRYPOINT ["/main"]