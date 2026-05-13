FROM --platform=$BUILDPLATFORM golang:1.21 AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

RUN go build -trimpath -ldflags="-s -w" -o /out/tracking-events ./cmd/server


FROM gcr.io/distroless/static-debian12

COPY --from=build /out/tracking-events /tracking-events

ENV PORT=8080
EXPOSE 8080

CMD ["/tracking-events"]
