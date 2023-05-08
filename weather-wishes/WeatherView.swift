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
    @State private var manuallyEnteredCity = ""
    @State private var manuallyEnteredCityCoord: CLLocationCoordinate2D?
    
    

    
    var body: some View {
        NavigationView {
            List(0 ..< 1) { _ in
           
                if let weather = viewModel.weather {
                    Section {
                        VStack(alignment: .center) {
                            Spacer()
                            if !manuallyEnteredCity.isEmpty {
                                Text(manuallyEnteredCity)
                                    .font(.system(size: 35.0))
                                    .fontWeight(.bold)
                            } else {
                                Text(LocationManager.shared.city!)
                                    .font(.system(size: 35.0))
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            Image(systemName: "\(weather.currentWeather.symbolName).fill")
                                .font(.custom("Helvetica Neue", size: 130))
                            
                                .foregroundStyle(iconColor.setIconColor(icon: weather.currentWeather.symbolName)[0], iconColor.setIconColor(icon: weather.currentWeather.symbolName).count > 1 ? iconColor.setIconColor(icon: weather.currentWeather.symbolName)[1] : Color.black)
                            
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
                            HStack {
                                Text("UV Index")
                                Text("\(weather.currentWeather.uvIndex.value)")
                            }
                        }
                        .padding(.leading, 30)
                        
                        
                    }
                    
                    Section {
                            

                            HourlyForecastView(hourWeatherlist: viewModel.hourlyWeatherData)
                       
                
                            
                        
                       
                    }
                    
                
                
                    VStack(alignment: .leading) {
                        Text("Upcoming days")
                            .font(.headline)
                                .padding(.leading, 5)
                        Divider()
                    }
                    .padding(.top, 10)
                    .listRowSeparator(.hidden)
              
                    SevenDayForeCastView(dayWeatherList: weather.dailyForecast.forecast)
                    
         
                    
                } else {
                    ProgressView()
                        .task {
                            await viewModel.getWeather()
                        }
                }
                
            }
            .onChange(of: scenePhase) { newPhase in
                    
                if newPhase == .active {
                    Task {
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
                                .onSubmit {
                                    returnCityCoord(city: searchText) { (coordinates, error) in
                                        if let error = error {
                                            print("Error: \(error.localizedDescription)")
                                        } else if let coordinates = coordinates {
                                            manuallyEnteredCity = searchText
                                            // Do something with the coordinates here
                                            Task {
                                                await viewModel.getWeatherForManual(coord: coordinates)
                                            }
                                            searchText = ""
                                        }
                                    }
                                    
                                }
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
    
    
    func returnCityCoord(city: String, completionHandler: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let coordinates = placemark.location?.coordinate
                completionHandler(coordinates, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
