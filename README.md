# WeatherApp

A Flutter project using the OpenWeatherMap API with best practices.

## Getting Started 🚀

#### IMPORTANT!!!! ---- Environment Setup

- Make a copy of the `.env.example` file and name it `.env`.
- In the `.env` file, modify the `BASE_URL` and the `API_KEY` values to the correct ones (e.g. `BASE_URL=http://api.openweathermap.org/data/2.5`. Please note that the base URL does not have the trailing `/`). Without these, the application will not run as required.

#### Project Flavors

This project contains 3 flavours:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

Alternatively, on Visual Studio Code:

- Go to `Run and Debug`
- Select either `Launch development`, `Launch staging` or `Launch production` then click on the `Run` button as show below

_\*WeatherApp works on iOS & Android._

---

## Sample Screenshots 📲

### Cities

![nairobi](https://github.com/user-attachments/assets/eb33d412-82fd-4baa-866b-0c4c20bf1c13)

![tokyo](https://github.com/user-attachments/assets/61287bff-9f12-418d-b321-91a![City Not found0](https://github.com/user-attachments/assets/8953b1d2-c530-40cd-a522-19bf47f7d1a9)
0636ace02)

![joburg](https://github.com/user-attachments/assets/655785f6-65ec-44b8-b1e2-43a9ba460b9e)

### Errors

![invalid API key](https://github.com/user-attachments/assets/8ef03b9a-4da4-4c7c-bc39-87770e24c7b4)
![City Not found0](https://github.com/user-attachments/assets/b51b7a10-5ab0-426f-9960-be54b5c752f4)

### Internet Status

![offline](https://github.com/user-attachments/assets/f44011de-e3b1-4a9c-955b-a3ebd429d48f)
![online](https://github.com/user-attachments/assets/d2bba7b9-959b-4ff3-ab8c-8b6b05a25061)

### Last Updated Timestamp

![last updated](https://github.com/user-attachments/assets/166b67b9-f2ec-4627-8ad1-412b5570d36d)
