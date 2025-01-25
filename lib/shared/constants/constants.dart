import 'package:flutter_dotenv/flutter_dotenv.dart';

final String kApiKey = dotenv.env['API_KEY'] ?? '';
final String kBaseUrl = dotenv.env['BASE_URL'] ?? '';
