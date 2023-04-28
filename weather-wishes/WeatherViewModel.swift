//
//  WeatherViewModel.swift
//  weather-wishes
//
//  Created by Albin Sander on 2023-04-22.
//

import CoreLocation
import SwiftUI
import WeatherKit

@MainActor public class WeatherViewModel: ObservableObject {
    @Published var weather: Weather?
    
    static let location: CLLocation =
        .init(
            latitude: .init(LocationManager.shared.lat ?? 40.6481958786448),
            longitude: .init(LocationManager.shared.long ?? -73.95911458617056)
        )
    
    var hourlyWeatherData: [HourWeather] {
        if let weather = weather {
            return Array(weather.hourlyForecast.filter { hourlyWeather in
                hourlyWeather.date.timeIntervalSince(Date()) >= 0
            }.prefix(12))
        } else {
            return []
        }
    }
    
    func getWeather() async {
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                try await WeatherService.shared
                    .weather(for: WeatherViewModel.location)
            }.value
        } catch {
            fatalError("\(error)")
        }
    }
    
    func getWeatherForManual(coord: CLLocationCoordinate2D) async {
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                try await WeatherService.shared
                    .weather(for: location)
            }.value
        } catch {
            fatalError("\(error)")
        }

    }
    
    func returnSymbolColor() -> Color {
        let currentSymbol = weather?.currentWeather.symbolName
        switch currentSymbol {
        case "rain":
            return .blue
        case "clear":
            return .yellow
        case "cloud":
            return .gray
        case "sun.max":
            return .yellow
        case "cloud.sun":
            return .yellow
        case .none:
            return .gray
        case .some:
            return .gray
        }
    }
}
