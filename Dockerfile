FROM alpine:3
RUN apk add bash curl jq yq crane fish fzf

ENTRYPOINT [ "fish" ]
