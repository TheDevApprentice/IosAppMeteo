//
//  ContentView.swift
//  MeteoApp
//
//  Created by Tech Info on 2024-04-10.

import SwiftUI
import CoreLocation

func formatTemperature(_ temperature: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 1
    return "\(numberFormatter.string(for: temperature) ?? "")°C"
}

func formatDate(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    } else {
        return "Date inconnue"
    }
}

func formatDateForecast(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "d MM"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    } else {
        return "Date inconnue"
    }
}

let latitude = 46.116669
let longitude = -70.666664
let timezone = "America/New_York"
let forecastDays = 3

struct WeatherResponse: Decodable {
    let current: CurrentWeather
    let daily: DailyWeather
}

struct CurrentWeather: Decodable {
    let temperature_2m: Double
}

struct DailyWeather: Decodable {
    let time: [String]
    let weather_code: [Int]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
}

func imageName(forWeatherCode weatherCode: Int) -> String {
    switch weatherCode {
    case 0:
        return "sunny"
    case 1, 2, 3:
        return "cloudy"
    case 45, 48:
        return "rainy"
    case 51, 53, 55:
        return "rainy"
    case 56, 57:
        return "snowy"
    case 61, 63, 65:
        return "rainy"
    case 66, 67:
        return "rainy"
    case 71, 73, 75:
        return "snowy"
    case 77:
        return "snowy"
    case 80, 81, 82:
        return "rainy"
    case 85, 86:
        return "snowy"
    case 95:
        return "rainy"
    case 96, 99:
        return "rainy"
    default:
        return "unknown"
    }
}

func fetchWeatherData() async throws -> WeatherResponse{
    let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=\(timezone)&forecast_days=\(forecastDays)")!
    
    let (data, _) = try await URLSession.shared.data(from: url )

    let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
    
    print(decoded.self)
    return decoded.self
}

struct ContentView: View {
    @State private var weatherResponse: WeatherResponse?
    
    var body: some View {
        VStack {
            if let response = weatherResponse {
                GroupBox() {
                    GroupBox() {
                        VStack {
                            Text("Saint-Georges")
                            Text(formatDate(response.daily.time[0]))

                            Image(imageName(forWeatherCode: response.daily.weather_code[1]))
                                .resizable()
                                .frame(width: 380, height: 380)
                                .foregroundColor(.accentColor)
                            
                            Text(formatTemperature(response.current.temperature_2m))
                                   .padding(.top, 10)
                               
                               Spacer()

                        }
                    }
                    
                    GroupBox() {
                        VStack {
                            Text("A venir")
                            HStack {
                            ForEach(0..<response.daily.temperature_2m_max.count, id: \.self) { index in
                             
                                    GroupBox() {
                                        VStack {
                                            Image(imageName(forWeatherCode: response.daily.weather_code[index]))
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.accentColor)
                                            
                                            Text(formatDateForecast(response.daily.time[index]))
                                            Text(formatTemperature(response.daily.temperature_2m_min[index]))
                                            Text(formatTemperature(response.daily.temperature_2m_max[index]))

                                        }
                                    }
                                }
                            }
                        }
                    }.frame(maxWidth: .infinity) 
                }
            } else {
                Text("Chargement en cours...")
                    .padding()
            }
        }
        .onAppear {
            Task {
                do {
                    let weatherData = try await fetchWeatherData()
                    weatherResponse = weatherData
                } catch {
                    print(error)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
