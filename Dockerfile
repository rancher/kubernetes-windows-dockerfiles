ARG  SERVERCORE_VERSION

FROM golang:1.16-nanoserver-1809 AS build-env

WORKDIR /project
ADD . /project
RUN cd /project
RUN go build -o bin/wincat.exe cmd/wincat/main.go
#RUN go build -o bin/pauseloop.exe cmd/pauseloop/main.go

FROM mcr.microsoft.com/windows/nanoserver:${SERVERCORE_VERSION}
COPY --from=build-env /project/bin/wincat.exe "c:\\windows\\system32\\wincat.exe"
#COPY --from=build-env /project/bin/pauseloop.exe "c:\\windows\\system32\\pauseloop.exe"
CMD  ["cmd", "/c", "ping", "-t", "127.0.0.1"]
