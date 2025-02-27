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
- Select either `Launch development`, `Launch staging` or `Launch production` then click on the `Run` button as shown below

<img width="380" alt="Screenshot 2025-01-26 at 00 50 22" src="https://github.com/user-attachments/assets/86372f9a-b004-4edd-a8b6-fa7d194f9630" />
<img width="360" alt="Screenshot 2025-01-26 at 00 50 15" src="https://github.com/user-attachments/assets/ce6f9ec1-51a3-4803-8bce-db979a361c24" />



_\*WeatherApp works on iOS & Android._

---

## Sample Screenshots 📲

### Cities, Search, Last Updated & Online Status
![Image_1](https://github.com/user-attachments/assets/28f633bc-fdf1-49ac-8dc2-e92f8542731a)

![Image_2](https://github.com/user-attachments/assets/f44c09b2-9c84-4930-8039-2e6e5e68c143)

![Image_3](https://github.com/user-attachments/assets/2826dae8-dbc9-4b2b-bed4-f38e1491d3b3)


