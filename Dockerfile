FROM alpine:3
RUN apk add bash curl jq yq crane fish

ENTRYPOINT [ "fish" ]
