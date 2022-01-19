FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 44374

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["LoRa_Sensor_Network_Blazor_Server_App.csproj", "."]
RUN dotnet restore "LoRa_Sensor_Network_Blazor_Server_App.csproj"
COPY . .
RUN dotnet build "LoRa_Sensor_Network_Blazor_Server_App.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "LoRa_Sensor_Network_Blazor_Server_App.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "LoRa_Sensor_Network_Blazor_Server_App.dll"]