//
//  Weather.swift
//  
//
//  Created by Emmanuel Cruz on 8/15/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

class Weather {
    
    private var _temp: Double!
    private var _hum: Int!
    private var _wind: Double!
    private var _condition: String!
    private var _zip: String!
    private var _url: String!
    private var _cityName: String!
    
    
    var temp: Double {
        return _temp
    }
    
    var hum: Int {
        return _hum
    }
    
    var wind: Double {
        return _wind
    }
    
    var condition: String {
        return _condition
    }
    
    var cityName: String {
        return _cityName
    }
    
    init(zip: String) {
        self._zip = zip
        
       _url = "http://api.openweathermap.org/data/2.5/weather?zip=\(zip),us&APPID=d526468c0e50edfcf44fe7c0dd42ba88"
    }
    
    func downloadDetails(completed: DownloadComplete) {
        
        
        let url = NSURL(string: _url)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                guard let cityName = dict["name"] as? String else {
                    print("Invalid Zip Code")
                    return
                }
                self._cityName = cityName

                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let temp = main["temp"] as? Double {
                        self._temp = temp
                    }
                    if let hum = main["humidity"] as? Int {
                        self._hum = hum
                    }
                }
                if let wind = dict["wind"] as? Dictionary<String, AnyObject> {
                    if let speed = wind["speed"] as? Double {
                        self._wind = speed
                    }
                }
                if let weatherDesc = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let desc = weatherDesc[0]["description"] as? String {
                        self._condition = desc
                    }
                }
            }
            completed()
        }

    }
}



