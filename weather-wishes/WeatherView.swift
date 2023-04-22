//
//  WeatherView.swift
//  weather-wishes
//
//  Created by Albin Sander on 2022-06-08.
//

import CoreLocation
import SwiftUI
import WeatherKit

struct WeatherView: View {
    @Environment(\.scenePhase) var scenePhase
    static let location: CLLocation =
        .init(
            latitude: .init(LocationManager.shared.lat ?? 37.3230),
            longitude: .init(LocationManager.shared.long ?? 122.0322)
        )
    
    @State var weather: Weather?
    var hourlyWeatherData: [HourWeather] {
        if let weather {
            return Array(weather.hourlyForecast.filter { hourlyWeather in
                hourlyWeather.date.timeIntervalSince(Date()) >= 0
            }.prefix(24))
        } else {
            return []
        }
    }
    
    func getWeather() async {
   

        do {
            weather = try await Task.detached(priority: .userInitiated) {
                try await WeatherService.shared
                    .weather(for: WeatherView.location)
                    
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
        case .none:
            return .gray
        case .some:
            return .gray
        }
    }
    
    var body: some View {
        List(0 ..< 1) { _ in
       
                if let weather = weather {
                    VStack {
                        Spacer()
                        Text(LocationManager.shared.city!)
                            .font(.system(size: 35.0))
                            .fontWeight(.bold)
          
                        Spacer()
                        Image(systemName: weather.currentWeather.symbolName)
                            .font(.custom("Helvetica Neue", size: 130))
                            .foregroundColor(returnSymbolColor())
                        Spacer()
                        HStack {
                            Text(weather
                                .currentWeather.temperature.formatted()
                            )
                            
                            .font(.system(size: 35.0))
                            .fontWeight(.bold)
                        }
                        HStack {
                            Text("Feels like temperature:")
                            Text(weather.currentWeather.apparentTemperature
                                .formatted())
                        }
                        .padding(.top)
      
                        .font(.system(size: 20))
                        HourlyForecastView(hourWeatherlist: hourlyWeatherData)
               
                        Spacer()
                        HStack {
                            Text("Wind:")
                            Text("\(weather.currentWeather.wind.speed.formatted())")
                        }
                       
                        
                     
        
                    }
                    .onChange(of: scenePhase) { newPhase in
                        
                        if newPhase == .active {
                            Task {
                                await getWeather()
                            }
                        }
                    }
                    VStack {
                        SevenDayForeCastView(dayWeatherList: (weather.dailyForecast.forecast))
                    }
                 
                } else {
                    ProgressView()
                        .task {
                            await getWeather()
                        }
                }
           
        }
        .refreshable {
            Task {
                await getWeather()
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
