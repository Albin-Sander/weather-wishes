//
//  SevenDayForeCastView.swift
//  weather-wishes
//
//  Created by Albin Sander on 2023-04-22.
//

import SwiftUI
import WeatherKit

extension Date {
    func formatAsAbbreviatedDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    func formatAsAbbreviatedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: self)
    }
}

struct SevenDayForeCastView: View {
    let dayWeatherList: [DayWeather]
    var body: some View {
        VStack(alignment: .leading) {
            Text("7 day forecast")
            
            ForEach(dayWeatherList, id: \.date) { dailyWeather in
                HStack {
                    Text(dailyWeather.date.formatAsAbbreviatedDay())
                    Image(systemName: dailyWeather.symbolName)
                    
                    Text(dailyWeather.highTemperature.formatted())
                }
            }
            

        }
        .onAppear {
            print("här \(dayWeatherList)")
        }
    }
}


