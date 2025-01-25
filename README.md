# WeatherApp

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Flutter project using the openweather API with best-practices.
---

## Getting Started 🚀
#### IMPORTANT!!!! ---- Environment Setup

- Make a copy of the `.env.example` file and name it `.env`.
- In the `.env` file, modify the `BASE_URL` and the `API_KEY` values to the correct ones (e.g. `BASE_URL=http://api.openweathermap.org/data/2.5`. Please note that the base url does not have the trailing `/`). Without these the application will not run as required.

#### Project Flavors

This project contains 3 flavors:

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

_\*Assessment works on iOS, Android, Web, and Windows._

---

## Sample Screenshots 📲
![nairobi](https://github.com/user-attachments/assets/eb33d412-82fd-4baa-866b-0c4c20bf1c13)

![tokyo](https://github.com/user-attachments/assets/61287bff-9f12-418d-b321-91a0636ace02)

![joburg](https://github.com/user-attachments/assets/655785f6-65ec-44b8-b1e2-43a9ba460b9e)
