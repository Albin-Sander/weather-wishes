//
//  HourlyForeCastWidgetView.swift
//  weather-wishes
//
//  Created by Albin Sander on 2023-04-23.
//

import SwiftUI

//
//  HourlyForecastView.swift
//  weather-wishes
//
//  Created by Albin Sander on 2023-04-22.
//

import SwiftUI
import WeatherKit

struct HourlyForecastWidgetView: View {
    let hourWeatherlist: [HourWeather]
    let iconColor = WeatherIconColor()
    
    func getHourFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "HH"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func formatTemperature(temperature: Measurement<UnitTemperature>) -> String {
        let temperatureFormatter = MeasurementFormatter()
        temperatureFormatter.unitOptions = .temperatureWithoutUnit
        return temperatureFormatter.string(from: temperature)
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(hourWeatherlist, id: \.date) { hourWeatherItem in
                        
                    HStack {
                        VStack {
                            Text(getHourFromDate(date: hourWeatherItem.date))
//                            Text(hourWeatherItem.date.formatted(date: .omitted, time: .shortened))
                                .padding(.bottom, 5)
        
                            Image(systemName: "\(hourWeatherItem.symbolName).fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(iconColor.setIconColor(icon: hourWeatherItem.symbolName)[0], iconColor.setIconColor(icon: hourWeatherItem.symbolName).count > 1 ? iconColor.setIconColor(icon: hourWeatherItem.symbolName)[1] : Color.black)
                                .font(.headline)
                            
         
                            Text(hourWeatherItem.temperature.formatted())
                                .padding(.top, 7)
                        }
                           
                        Divider()
                            .opacity(0)
                    }
                }
            }
        }
        .frame(height: 100)
    }
}
