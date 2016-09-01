//
//  ViewController.swift
//  Weather
//
//  Created by Emmanuel Cruz on 8/14/16.
//  Copyright © 2016 DevPro. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

var globalPlacemark = CLPlacemark?()

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var humLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    
    var weather: Weather!
    var IsSearchMode: Bool = false
    var searchBarInput: String = ""
    var convertKelvin: Double = 0.0
    
    let locationManager = CLLocationManager()
    var specialPlacemark = CLPlacemark()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemark, error) in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
        }
            
            if placemark!.count > 0 {
                 let pm = placemark![0] as CLPlacemark
                    self.displayLocationInfo(pm)
            } else {
                 print("Problem with data received from geocoder")
            }
        }
    }
    
        func displayLocationInfo(placemark: CLPlacemark) {
            locationManager.stopUpdatingLocation()
            
            if placemark.postalCode != nil {
                weather = Weather(zip: placemark.postalCode!)
                weather.downloadDetails { () -> () in
                    self.updateUI()
                }
            }
            
            
        }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location" + error.localizedDescription)
    }
    
    func updateUI() {
        convertKelvin = weather.temp * 1.8 - 459.67
        tempLbl.text = "\(Int(convertKelvin))°"
        humLbl.text = "\(weather.hum)"
        windLbl.text = "\(weather.wind)"
        conditionLbl.text = weather.condition.capitalizedString
        cityName.text = weather.cityName
        cityName.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, 30)
        
        manageImages()
    }
    
    func manageImages() {
        if weather.condition == "light rain" {
            weatherImg.image = UIImage(assetIdentifier: .lightRain)
            print(weather.condition)
        }
    }
  
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if IsSearchMode {
            weather = Weather(zip: searchBarInput)
            view.endEditing(true)
            
             weather.downloadDetails { () -> () in
                 self.updateUI()
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            IsSearchMode = false
            view.endEditing(true)
        } else {
            IsSearchMode = true
            searchBarInput = searchBar.text!
        }
    }
}

