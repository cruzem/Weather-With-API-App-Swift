//
//  SetImages.swift
//  Weather
//
//  Created by Emmanuel Cruz on 8/26/16.
//  Copyright © 2016 DevPro. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    enum WeatherDescription : String {
        case lightRain = "OccLightRain"
        case overcastClouds = "Overcast"
        case brokenClouds = "Cloudy"
//        case fewClouds = "Few Clouds"
//        case scatteredClouds = "Scattered Clouds"
//        case skyClear = "Sky Is Clear"
//        case moderateRain = "Moderate Rain"
        }
    
    convenience init(assetIdentifier: WeatherDescription) {
        self.init(named: assetIdentifier.rawValue)!
    }
}