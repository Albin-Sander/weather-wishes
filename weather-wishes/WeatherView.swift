//
//  WeatherView.swift
//  weather-wishes
//
//  Created by Albin Sander on 2022-06-08.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct WeatherView: View {
    static let location: CLLocation =
        CLLocation(
            latitude: .init(LocationManager.shared.lat!),
            longitude: .init(LocationManager.shared.long!)
        )
    
    @State var weather: Weather?
    
    init() {
        print("I'm printing this")
        print(LocationManager.shared.lat)
        print(LocationManager.shared.long)
    }
    
    func getWeather() async {
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                return try await WeatherService.shared
                    .weather(for: WeatherView.location)
            }.value
        } catch {
            fatalError("\(error)")
        }
    }
    
    
    
    
    var body: some View {
        VStack {
            if let weather = weather {
                Text(weather.currentWeather.temperature.description)
            } else {
                ProgressView()
                    .task {
                        await getWeather()
                    }
            }
            if let location = LocationManager.shared.userLocation {
                Text("\(location)")
            }
            
        }
    }
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
