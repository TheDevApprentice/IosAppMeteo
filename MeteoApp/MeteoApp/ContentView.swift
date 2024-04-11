//
//  ContentView.swift
//  MeteoApp
//
//  Created by Tech Info on 2024-04-10.

import SwiftUI
import CoreLocation

func getCurrentDate() -> String{
    print("date", Date.now)
    let currentDate = Date()
    let dateFormator = DateFormatter()
    dateFormator.dateFormat = "dd mm yyyy"
    return dateFormator.string(from: currentDate)
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
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
}

func fetchWeatherData() async throws -> WeatherResponse{
    let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=\(timezone)&forecast_days=\(forecastDays)")!
    
    let (data, _) = try await URLSession.shared.data(from: url )
    let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
    
    print(decoded.self)
    return decoded.self
}


struct ContentView: View {
    @State private var WeatherResponse : WeatherResponse?
    var body: some View {
        VStack {
            GroupBox() { // on mettra l image correspondant a la
                GroupBox() { // on mettra l image correspondant a la meteo
                    VStack {
                        Text("Saint-Georges")
                        Text(getCurrentDate())
                        
                        Image("rainy")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .foregroundColor(.accentColor)
                        Text("temperature")
                    }
                }
                GroupBox() {
                    VStack {
                        Text("A venir")
                        HStack {
                            GroupBox() {
                                VStack {
                                    Image("rainy")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.accentColor)
                                    Text("date")
                                    Text("Min")
                                    Text("Max")
                                }
                            }
                            GroupBox() {
                                VStack {
                                    Image("rainy")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.accentColor)
                                    Text("date")
                                    Text("Min")
                                    Text("Max")
                                }
                            }
                            GroupBox() {
                                VStack {
                                    Image("rainy")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.accentColor)
                                    Text("date")
                                    Text("Min")
                                    Text("Max")
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear{
            Task {
                do {
                    let weatherData = try await fetchWeatherData()

                    print(weatherData)
                } catch {
                    print(error)
                }
            }        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
