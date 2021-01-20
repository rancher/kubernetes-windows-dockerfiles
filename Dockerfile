ARG  SERVERCORE_VERSION

FROM mcr.microsoft.com/windows/nanoserver:${SERVERCORE_VERSION}
CMD  ["cmd", "/c", "ping", "-t", "127.0.0.1"]
