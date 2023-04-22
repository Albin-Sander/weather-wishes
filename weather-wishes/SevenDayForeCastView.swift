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
     
        VStack {
            VStack(alignment: .leading) {
                ForEach(dayWeatherList, id: \.date) { dailyWeather in
                    VStack {
                        HStack {
                            Text(dailyWeather.date.formatAsAbbreviatedDay())
                            Image(systemName: dailyWeather.symbolName)
                            Spacer()
                            Text(dailyWeather.highTemperature.formatted())
                        }
                    }
                    Divider()
                }
            }

        }
            .padding()
       
    }
}


