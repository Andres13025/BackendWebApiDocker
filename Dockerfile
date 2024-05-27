# Utiliza una imagen base de .NET para ASP.NET Core
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copia los archivos del proyecto y restaura las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copia el resto de los archivos y compila la aplicaci�n
COPY . ./
RUN dotnet publish -c Release -o out

# Crea una imagen final m�s peque�a
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "WebApiProducer.dll"]

