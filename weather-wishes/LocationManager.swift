//
//  LocationManager.swift
//  weather-wishes
//
//  Created by Albin Sander on 2022-06-11.
//

import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var long: Double?
    @Published var lat: Double?
    @Published var city: String?
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
      
        manager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, status: CLAuthorizationStatus) {
        
        switch status {
            
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("restricted")
        case .denied:
            print("auth denied")
        case .authorizedAlways:
            print("auth always")
        case .authorizedWhenInUse:
            print("Auth when in use")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        self.coordinates = location.coordinate
        self.long = location.coordinate.longitude
        self.lat = location.coordinate.latitude
        
        
        let geoCoder = CLGeocoder()
        
                geoCoder.reverseGeocodeLocation(location, completionHandler:
                    {
                        placemarks, error -> Void in

                        // Place details
                        guard let placeMark = placemarks?.first else { return }

                        // Location name
                        if let locationName = placeMark.location {
                            print(locationName)
                        }
                        
                        // City
                        if let city = placeMark.subAdministrativeArea {
                            print(city)
                            self.city = city
                        }
                       
                })
        
    }
}
