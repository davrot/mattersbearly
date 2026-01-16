FROM mattermost/mattermost-build-server:1.24.11 AS builder

COPY . /mattermost

WORKDIR /mattermost/server
RUN go mod edit -replace github.com/mattermost/mattermost/server/public=./public
RUN go mod edit -replace github.com/mattermost/mattermost/server/public/shared=./public/shared

WORKDIR /mattermost/server/public
RUN go mod edit -replace github.com/mattermost/mattermost/server/v8=../

WORKDIR /mattermost/server
RUN go mod tidy
RUN go mod download

WORKDIR /mattermost/server/public
RUN go mod tidy
RUN go mod download

WORKDIR /mattermost/server
RUN make build-linux BUILD_HASH=local-dev BUILD_NUMBER=11.2.2

WORKDIR /mattermost/webapp
RUN make dist

WORKDIR /
RUN mkdir -p /mattermost/config
RUN OUTPUT_CONFIG=/mattermost/config/config.json /mattermost/server/bin/config_generator

FROM ubuntu:24.04

ARG PUID=2000
ARG PGID=2000

WORKDIR /mattermost

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    ca-certificates curl media-types mailcap unrtf wv poppler-utils tidy tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /mattermost/config /mattermost/data /mattermost/logs /mattermost/plugins /mattermost/client/plugins /mattermost/prepackaged_plugins /mattermost/.postgresql mattermost/client/plugins \
    && groupadd --gid ${PGID} mattermost \
    && useradd --uid ${PUID} --gid ${PGID} --home-dir /mattermost mattermost

COPY --from=builder --chown=mattermost:mattermost /mattermost/config/config.json /mattermost/config/config.json
COPY --from=builder /mattermost/server/bin/mattermost /mattermost/bin/
COPY --from=builder /mattermost/server/bin/mmctl /mattermost/bin/
COPY --from=builder /mattermost/webapp/channels/dist/. /mattermost/client/
COPY --from=builder /mattermost/server/i18n/. /mattermost/i18n/
COPY --from=builder /mattermost/server/fonts/. /mattermost/fonts/
COPY --from=builder /mattermost/server/templates/. /mattermost/templates/

USER mattermost
EXPOSE 8065
ENTRYPOINT ["/mattermost/bin/mattermost"]

