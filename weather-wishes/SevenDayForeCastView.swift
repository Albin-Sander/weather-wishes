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
    let iconColor = WeatherIconColor()
    var body: some View {
     
        VStack {
            VStack(alignment: .leading) {
                ForEach(dayWeatherList, id: \.date) { dailyWeather in
                    VStack {
                        HStack {
                            VStack {
                                Text(dailyWeather.date.formatAsAbbreviatedDay())
                                Text(dailyWeather.precipitationChance.formatted())
                                    .font(.footnote)
                            }
                            Image(systemName: "\(dailyWeather.symbolName).fill")
                                .foregroundStyle(iconColor.setIconColor(icon: dailyWeather.symbolName)[0], iconColor.setIconColor(icon: dailyWeather.symbolName).count > 1 ? iconColor.setIconColor(icon: dailyWeather.symbolName)[1] : Color.black)
                                .font(.system(size: 20))
                                .padding(.leading, 20)
                            Spacer()
                            Text(dailyWeather.lowTemperature.formatted())
                         Image(systemName: "arrow.right")
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


