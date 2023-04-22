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
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        List(0 ..< 1) { _ in
       
            if let weather = viewModel.weather {
                VStack {
                    Spacer()
                    Text(LocationManager.shared.city!)
                        .font(.system(size: 35.0))
                        .fontWeight(.bold)
          
                    Spacer()
                    Image(systemName: weather.currentWeather.symbolName)
                        .font(.custom("Helvetica Neue", size: 130))
                        .foregroundColor(viewModel.returnSymbolColor())
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
                
                    HStack {
                        Text("Wind")
                        Text((weather.currentWeather.wind.speed.formatted()))
                    }

                    HourlyForecastView(hourWeatherlist: viewModel.hourlyWeatherData)
               
                    Spacer()
                 
                }
                .onChange(of: scenePhase) { newPhase in
                        
                    if newPhase == .active {
                        Task {
                            await viewModel.getWeather()
                        }
                    }
                }
          
                    SevenDayForeCastView(dayWeatherList: weather.dailyForecast.forecast)
                
                 
            } else {
                ProgressView()
                    .task {
                        await viewModel.getWeather()
                    }
            }
        }
        .refreshable {
            Task {
                await viewModel.getWeather()
            }
        }
        
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
