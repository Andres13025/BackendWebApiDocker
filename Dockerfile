# Etapa base: imagen base de ASP.NET Core
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5243
EXPOSE 7068

# Etapa de compilación
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["WebApiProducer.csproj", "."]
RUN dotnet restore "WebApiProducer.csproj"
COPY . .
RUN dotnet build "WebApiProducer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WebApiProducer.csproj" -c Release -o /app/publish

# Etapa final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY aspnetapp.pfx . 
ENV ASPNETCORE_Kestrel__Certificates__Default__Path="aspnetapp.pfx"
ENV ASPNETCORE_Kestrel__Certificates__Default__Password="yourpassword"
ENTRYPOINT ["dotnet", "WebApiProducer.dll"]
