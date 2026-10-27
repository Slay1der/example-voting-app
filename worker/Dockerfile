FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:8.0@sha256:ff39a765f04619c8d146796fc09b38499ae5984f4a2a4c3a0a57d0022855daee AS build
ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

WORKDIR /source
COPY *.csproj .
RUN dotnet restore -a $TARGETARCH

COPY . .
RUN dotnet publish -c release -o /app -a $TARGETARCH --self-contained false --no-restore

FROM mcr.microsoft.com/dotnet/runtime:8.0@sha256:ac29abc7855ef3dd4697be50ac8baa99151d893d5c4545f48b44579ce2d8f439
RUN useradd --create-home --uid 10001 appuser
WORKDIR /app
COPY --from=build --chown=appuser:appuser /app .
USER appuser
ENTRYPOINT ["dotnet", "Worker.dll"]