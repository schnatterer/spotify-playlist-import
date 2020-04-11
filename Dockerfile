FROM golang:1.14
WORKDIR /go/src/github.com/schnatterer/spotify-playlist-import
COPY . .
RUN go build -ldflags "-linkmode external -extldflags -static" -a main.go
RUN ls -la .

FROM scratch
COPY --from=0 /go/src/github.com/schnatterer/spotify-playlist-import/main /main
CMD ["/main"]