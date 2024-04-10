//
//  ContentView.swift
//  MeteoApp
//
//  Created by Tech Info on 2024-04-10.

import SwiftUI
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var completionHandler: ((String?) -> Void)?

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    func getCurrentCity(completion: @escaping (String?) -> Void) {
        self.completionHandler = completion
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            self.completionHandler?(nil)
            return
        }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                self.completionHandler?(nil)
                return
            }

            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    self.completionHandler?(city)
                } else {
                    print("No city found")
                    self.completionHandler?(nil)
                }
            } else {
                print("No placemarks found")
                self.completionHandler?(nil)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        self.completionHandler?(nil)
    }
}

func getCurrentDate() -> String{
    print("date", Date.now)
    let currentDate = Date()
    let dateFormator = DateFormatter()
    dateFormator.dateFormat = "dd mm yyyy"
    return dateFormator.string(from: currentDate)
}

func getCurrentWeather(date: Date) {
    
}

func getWeatherCode() {
    print("localisation")
}

func getWeatherToCome() {
    print("localisation")
}

func celcuisToFareinteit() {
    print("localisation")
}

struct ContentView: View {
    var body: some View {
        VStack {
            GroupBox() { // on mettra l image correspondant a la
                GroupBox() { // on mettra l image correspondant a la meteo
                    VStack {
                        Text(getLocalisation())
                        Text(getCurrentDate())
                        
                        Image("rainy")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .foregroundColor(.accentColor)
                        Text("temperature")
                    }
                }
                GroupBox() { // on mettra la temperature meteo
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
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
