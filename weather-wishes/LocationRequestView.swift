//
//  LocationRequestView.swift
//  weather-wishes
//
//  Created by Albin Sander on 2022-06-11.
//

import SwiftUI

struct LocationRequestView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "sunrise.fill")
                .font(.system(size: 80))
                .foregroundColor(.yellow)
                .padding()
                .background(Color.blue)
                .cornerRadius(20)
            
            
            
            Spacer()
            Text("Please allow location access")
            Button {
                LocationManager.shared.requestLocation()
            } label: {
                Text("Allow Location")
                    .padding()
                    .foregroundColor(Color.white)
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.horizontal, -32)
            .background(Color.blue)
            .clipShape(Capsule())
            .padding()
        }
        
        
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
