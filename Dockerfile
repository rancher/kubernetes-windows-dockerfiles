ARG  SERVERCORE_VERSION

FROM rancher/golang:1.16-windowsservercore AS build-env

WORKDIR /project
ADD . /project
RUN cd /project
RUN go build -o bin/wincat.exe cmd/wincat/main.go

FROM mcr.microsoft.com/windows/nanoserver:${SERVERCORE_VERSION}
COPY --from=build-env /project/bin/wincat.exe "c:\\windows\\system32\\wincat.exe"
CMD  ["cmd", "/c", "ping", "-t", "127.0.0.1"]
