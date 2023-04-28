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
    enum FocusedField {
            case searchText
        }
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = WeatherViewModel()
    let iconColor = WeatherIconColor()
    @State private var showTextfield = false
   @State var searchText = ""
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationView {
            List(0 ..< 1) { _ in
           
                if let weather = viewModel.weather {
                    Section {
                        VStack {
                            Spacer()
                            Text(LocationManager.shared.city!)
                                .font(.system(size: 35.0))
                                .fontWeight(.bold)
                  
                            Spacer()
                            Image(systemName: "\(weather.currentWeather.symbolName).fill")
                                .font(.custom("Helvetica Neue", size: 130))
                     
                                .foregroundStyle(iconColor.setIconColor(icon: weather.currentWeather.symbolName)[0], iconColor.setIconColor(icon: weather.currentWeather.symbolName).count > 1 ? iconColor.setIconColor(icon: weather.currentWeather.symbolName)[1] : Color.black)
                                .onAppear {
                                    print(weather.currentWeather.symbolName)
                                }
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
                                Text(weather.currentWeather.wind.speed.formatted())
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
                    }
                    VStack(alignment: .leading) {
                        Text("Upcoming days")
                            .font(.headline)
                                .padding(.leading, 5)
                        Divider()
                    }
                    .listRowSeparator(.hidden)
              
                    SevenDayForeCastView(dayWeatherList: weather.dailyForecast.forecast)
                    
         
                    
                } else {
                    ProgressView()
                        .task {
                            await viewModel.getWeather()
                        }
                }
                
            }
            .listStyle(.insetGrouped)
            .listRowSeparator(.hidden)
            .refreshable {
                Task {
                    await viewModel.getWeather()
                }
        }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if showTextfield {
                            TextField("Search city",text: $searchText)
                                .focused($focusedField, equals: .searchText)
                        }
                        Button(action: {
                            showTextfield.toggle()
                            focusedField = .searchText
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        
                     
                    }
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
