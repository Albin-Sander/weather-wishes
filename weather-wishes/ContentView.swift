//
//  ContentView.swift
//  weather-wishes
//
//  Created by Albin Sander on 2022-06-08.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager.shared
    var body: some View {
        
        Group {
            if(locationManager.userLocation == nil) {
                LocationRequestView()
            } else {
                WeatherView()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
