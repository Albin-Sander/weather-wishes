//
//  HourlyForecastView.swift
//  weather-wishes
//
//  Created by Albin Sander on 2023-04-22.
//

import SwiftUI
import WeatherKit

struct HourlyForecastView: View {
    let hourWeatherlist: [HourWeather]
    
    var body: some View {
        VStack {
            Text("Hourly forecast")
            VStack(alignment: .leading) {
                ForEach(hourWeatherlist, id: \.date) { hourWeatherItem in
                        
                    VStack {
                        HStack {
                            Rectangle()
                                .fill(hourWeatherItem.precipitationChance > 0 ? .blue : .gray)
                                .frame(width: 10, height: 40)
                            Text(hourWeatherItem.date.formatted(date: .omitted, time: .shortened))
                                .padding(.leading, 5)
                            if hourWeatherItem.symbolName == "rain" || hourWeatherItem.symbolName == "showers" {
                                Image(systemName: "\(hourWeatherItem.symbolName)")
                                    .foregroundColor(.blue)
                                Text("Rain")
                            } else if hourWeatherItem.symbolName == "clear" {
                                Image(systemName: "\(hourWeatherItem.symbolName)")
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "\(hourWeatherItem.symbolName)")
                                    .foregroundColor(.gray)
                                Text("\(hourWeatherItem.precipitationChance.formatted())")
                            }
                                
                            Spacer()
                            Text(hourWeatherItem.temperature.formatted())
                                 
                                .padding(.trailing, 5)
                            
                        }
                           
                        Divider()
                    }
                }
            }
            .padding()
        }
    }
}
