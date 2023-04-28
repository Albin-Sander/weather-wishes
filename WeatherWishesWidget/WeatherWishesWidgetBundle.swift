//
//  WeatherWishesWidgetBundle.swift
//  WeatherWishesWidget
//
//  Created by Albin Sander on 2023-04-23.
//

import WidgetKit
import SwiftUI

@main
struct WeatherWishesWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWishesWidget()
        WeatherWishesWidgetLiveActivity()
    }
}
