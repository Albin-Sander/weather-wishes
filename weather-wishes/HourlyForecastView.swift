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
    let iconColor = WeatherIconColor()
    @State private var showMore = false
    @Binding var selectedItem: String
    @Environment(\.colorScheme) var colorScheme
    
   
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ForEach(hourWeatherlist, id: \.date) { hourWeatherItem in
                        
                    VStack {
                        HStack {
                            Rectangle()
                                .fill(hourWeatherItem.precipitationChance > 0 ? .blue : .gray)
                                .frame(width: 10, height: 40)
                            Text(hourWeatherItem.date.formatted(date: .omitted, time: .shortened))
                                .padding(.leading, 5)
                         
                            if colorScheme == .light {
                                Image(systemName: "\(hourWeatherItem.symbolName)")
                                    .foregroundStyle(iconColor.setIconColor(icon: hourWeatherItem.symbolName)[0], iconColor.setIconColor(icon: hourWeatherItem.symbolName).count > 1 ? iconColor.setIconColor(icon: hourWeatherItem.symbolName)[1] : Color.black)
                                    .font(.custom("Helvetica Neue", size: 20))
                                
                            } else {
                                Image(systemName: "\(hourWeatherItem.symbolName).fill")
                                    .foregroundStyle(iconColor.setIconColorDarkMode(icon: hourWeatherItem.symbolName)[0], iconColor.setIconColorDarkMode(icon: hourWeatherItem.symbolName).count > 1 ? iconColor.setIconColorDarkMode(icon: hourWeatherItem.symbolName)[1] : Color.black)
                                    .font(.custom("Helvetica Neue", size: 20))
                            }
                                
                            Spacer()
                            switch selectedItem {
                            case "Feels like":
                                Text(hourWeatherItem.apparentTemperature.formatted())
                            case "Precip":
                                Text("\(hourWeatherItem.precipitationChance.formatted()) %")
                            default:
                                Text(hourWeatherItem.temperature.formatted())
                                    .padding(.trailing, 5)
                            }
                            

                            
                                 
                                
                            
                        }
                        
                        if showMore {
                            
                            VStack {
                                Text(hourWeatherItem.wind.speed.formatted())
                                Text(hourWeatherItem.precipitationChance.description)
                            }
                        

                            
                        }
                           
                        Divider()
                    }
                   
                }
                
              
            }
           
        }
        .onTapGesture {
            showMore.toggle()
        }
    }
}
