//
//  WeatherIconColor.swift
//  weatherwishes
//
//  Created by Albin Sander on 20230425.
//

import Foundation
import SwiftUI

class WeatherIconColor {
    public func setIconColor(icon: String) -> [Color] {
        switch icon {
        case let x where x.contains("cloud.bolt.rain"):
            return [.gray, .blue]
        case let x where x.contains("cloud.sun"):
            return [.black, .yellow]
        case let x where x.contains("sun"):
            return [.yellow]
        case "cloud.moon":
            return [.black, .purple]
        case "moon.stars":
            return [.purple, .yellow]
        default:
            return [.black]
        }
    }
    
    
    public func setIconColorDarkMode(icon: String) -> [Color] {
        switch icon {
        case let x where x.contains("cloud.bolt.rain"):
            return [.gray, .blue]
        case let x where x.contains("cloud.sun"):
            return [.white, .yellow]
        case let x where x.contains("sun"):
            return [.yellow]
        case "cloud.moon":
            return [.white, .purple]
        case "moon.stars":
            return [.purple, .yellow]
        default:
            return [.white]
        }
    }
}

//  Clear
//  Cloudy
//  Dust
//  Fog
//  Haze
//  MostlyClear
//  MostlyCloudy
//  PartlyCloudy
//  ScatteredThunderstorms
//  Smoke
//  Breezy
//  Windy
//  Drizzle
//  HeavyRain
//  Rain
//  Showers
//  Flurries
//  HeavySnow
//  MixedRainAndSleet
//  MixedRainAndSnow
//  MixedRainfall
//  MixedSnowAndSleet
//  ScatteredShowers
//  ScatteredSnowShowers
//  Sleet
//  Snow
//  SnowShowers
//  Blizzard
//  BlowingSnow
//  FreezingDrizzle
//  FreezingRain
//  Frigid
//  Hail
//  Hot
//  Hurricane
//  IsolatedThunderstorms
//  SevereThunderstorm
//  Thunderstorm
//  Tornado
//  TropicalStorm
