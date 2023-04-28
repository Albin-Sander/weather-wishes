//
//  WeatherWishesWidget.swift
//  WeatherWishesWidget
//
//  Created by Albin Sander on 2023-04-23.
//

import WidgetKit
import SwiftUI
import CoreLocation
import WeatherKit

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        let temperatureString = "72°C"
        let formatter = MeasurementFormatter()
        let temperature = formatter.numberFormatter.number(from: temperatureString)?.doubleValue ?? 0
        let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
        let hour = [HourWeather]()
        return SimpleEntry(date: Date(), city: "Gothenburg", temp: measurement, symbol: "sun.max", hourlyWeatherData: hour)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let temperatureString = "72°C"
        let formatter = MeasurementFormatter()
        let temperature = formatter.numberFormatter.number(from: temperatureString)?.doubleValue ?? 0
        let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
        let hour = [HourWeather]()
        let entry = SimpleEntry(date: Date(), city: "Gothenburg", temp: measurement, symbol: "sun.max", hourlyWeatherData: hour) // snapshot humidity
            completion(entry)
        }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            let currentDate = Date()
    
       
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
            let userCity = "Gothenburg"
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            Task {
                do {
                    if let location = locationManager.location {
                        let currentWeather: Weather? = try await WeatherService.shared.weather(for: location)
                        var hourlyWeatherData: [HourWeather] {
                            if let weather = currentWeather {
                                return Array(weather.hourlyForecast.filter { hourlyWeather in
                                    hourlyWeather.date.timeIntervalSince(Date()) >= 0
                                }.prefix(5))
                            } else {
                                return []
                            }
                        }
                        let entry = SimpleEntry(date: currentDate, city: userCity, temp: (currentWeather?.currentWeather.temperature)!, symbol: currentWeather?.currentWeather.symbolName ?? "sun.max", hourlyWeatherData: hourlyWeatherData)
                        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                        
                        completion(timeline)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }


struct SimpleEntry: TimelineEntry {
    let date: Date
    let city: String
    let temp: Measurement<UnitTemperature>
    let symbol: String
    let hourlyWeatherData: [HourWeather]
}

extension Color {
  init?(_ hex: String) {
    var str = hex
    if str.hasPrefix("#") {
      str.removeFirst()
    }
    if str.count == 3 {
      str = String(repeating: str[str.startIndex], count: 2)
        + String(repeating: str[str.index(str.startIndex, offsetBy: 1)], count: 2)
        + String(repeating: str[str.index(str.startIndex, offsetBy: 2)], count: 2)
    } else if !str.count.isMultiple(of: 2) || str.count > 8 {
      return nil
    }
    guard let color = UInt64(str, radix: 16)
    else {
      return nil
    }
    if str.count == 2 {
      let gray = Double(Int(color) & 0xFF) / 255
      self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
    } else if str.count == 4 {
      let gray = Double(Int(color >> 8) & 0x00FF) / 255
      let alpha = Double(Int(color) & 0x00FF) / 255
      self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)
    } else if str.count == 6 {
      let red = Double(Int(color >> 16) & 0x0000FF) / 255
      let green = Double(Int(color >> 8) & 0x0000FF) / 255
      let blue = Double(Int(color) & 0x0000FF) / 255
      self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    } else if str.count == 8 {
      let red = Double(Int(color >> 24) & 0x000000FF) / 255
      let green = Double(Int(color >> 16) & 0x000000FF) / 255
      let blue = Double(Int(color >> 8) & 0x000000FF) / 255
      let alpha = Double(Int(color) & 0x000000FF) / 255
      self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    } else {
      return nil
    }
  }
}

struct WeatherWishesWidgetEntryView : View {
    var entry: Provider.Entry
    let iconColor = WeatherIconColor()
   
    var body: some View {
        ZStack {
            
            Color("#ADD8E6")
            VStack {
                HStack {
                    HStack {
                        Label {
                            Text(entry.temp.formatted())
                        } icon: {
                            Image(systemName: "\(entry.symbol).fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(iconColor.setIconColor(icon: entry.symbol)[0], iconColor.setIconColor(icon: entry.symbol).count > 1 ? iconColor.setIconColor(icon: entry.symbol)[1] : Color.black)
                        }
                      
                        .font(.headline)
                        .fontWeight(.bold)
                       
                       
                           
                    }
                    .padding(.top, 10)
                    .padding(.leading, 10)
                   
                    Spacer()
                 
                   
                        Text(entry.city)
                        .font(.headline)
                
                       
                        
                 
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                }
               
                HourlyForecastWidgetView(hourWeatherlist: entry.hourlyWeatherData)
            }
       
            
        }
    }
}

struct WeatherWishesWidget: Widget {
    private let kind = "WeatherWidgetExtension"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWishesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("This is a weather widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct WeatherWishesWidgetMedium: Widget {
    private let kind = "WeatherWidgetExtension"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWishesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("This is a weather widget.")
        .supportedFamilies([.systemMedium])
    }
}

//struct WeatherWishesWidget_Previews: PreviewProvider {
//   static let hour = [HourWeather]()
//    static var previews: some View {
//        WeatherWishesWidgetEntryView(entry: SimpleEntry(date: Date(), city: "Gothenburg", temp: 1, symbol: "sun.max", hourlyWeatherData: hour))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
