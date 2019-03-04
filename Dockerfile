ARG  SERVERCORE_VERSION

FROM mcr.microsoft.com/powershell:nanoserver-${SERVERCORE_VERSION}
CMD  ["cmd", "/c", "ping", "-t", "127.0.0.1"]
