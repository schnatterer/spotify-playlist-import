# Build Stage
FROM lacion/alpine-golang-buildimage:1.13 AS build-stage

LABEL app="build-spotify-playlist-import"
LABEL REPO="https://github.com/schnatterer/spotify-playlist-import"

ENV PROJPATH=/go/src/github.com/schnatterer/spotify-playlist-import

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ADD . /go/src/github.com/schnatterer/spotify-playlist-import
WORKDIR /go/src/github.com/schnatterer/spotify-playlist-import

RUN make build-alpine

# Final Stage
FROM schnatterer/spotify-playlist-import

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/schnatterer/spotify-playlist-import"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/spotify-playlist-import/bin

WORKDIR /opt/spotify-playlist-import/bin

COPY --from=build-stage /go/src/github.com/schnatterer/spotify-playlist-import/bin/spotify-playlist-import /opt/spotify-playlist-import/bin/
RUN chmod +x /opt/spotify-playlist-import/bin/spotify-playlist-import

# Create appuser
RUN adduser -D -g '' spotify-playlist-import
USER spotify-playlist-import

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/spotify-playlist-import/bin/spotify-playlist-import"]
