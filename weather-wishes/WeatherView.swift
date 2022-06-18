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
        latitude: .init(LocationManager.shared.lat ?? 37.3230),
        longitude: .init(LocationManager.shared.long ?? 122.0322)
    )
    
    @State var weather: Weather?
    
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
        ZStack {
            Color(.systemBlue).ignoresSafeArea()
            if let weather = weather {
                VStack {
                    Spacer()
                    Text(LocationManager.shared.city!)
                        .font(.system(size: 35.0))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: weather.currentWeather.symbolName)
                        .font(.custom("Helvetica Neue", size: 150))
                        .foregroundColor(Color.yellow)
                    Spacer()
                    HStack {
                        Text(weather
                            .currentWeather.temperature
                            .description
                        )
                        
                        .font(.system(size: 35.0))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        
                    }
                    HStack {
                        Text("Feels like temperature:")
                        Text(weather.currentWeather.apparentTemperature
                            .description)
                        
                    }
                    .padding(.top)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    Spacer()
                }
                .task {
                    await getWeather()
                }
                
            } else {
                ProgressView()
                    .task {
                        await getWeather()
                    }
            }
            
        }
        
        
    }
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
