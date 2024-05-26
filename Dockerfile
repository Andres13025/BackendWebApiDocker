# Paso 1: Utiliza la imagen base de ASP.NET Core
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5243 7068

# Paso 2: Copia los archivos publicados de la aplicación en la imagen
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "WebApiProducer.csproj"
RUN dotnet build "WebApiProducer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WebApiProducer.csproj" -c Release -o /app/publish

# Paso 3: Configura el contenedor para ejecutar la aplicación cuando se inicie
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY aspnetapp.pfx . 
ENV ASPNETCORE_Kestrel__Certificates__Default__Path="aspnetapp.pfx"
ENV ASPNETCORE_Kestrel__Certificates__Default__Password="yourpassword"
ENTRYPOINT ["dotnet", "WebApiProducer.dll"]
