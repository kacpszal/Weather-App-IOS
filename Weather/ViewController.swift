//
//  ViewController.swift
//  Weather
//
//  Created by un1kalny on 13/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var weatherStateLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var airPressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    var numberOfDay = 0
    var previousButtonShouldBeEnabled = false
    var nextButtonShouldBeEnabled = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        previousButton.isEnabled = previousButtonShouldBeEnabled
        nextButton.isEnabled = nextButtonShouldBeEnabled
        
        if(numberOfDay < 0) {
            numberOfDay = 0
        }
        
        if(numberOfDay > DayWeather.allDaysWeather.count - 1) {
            numberOfDay = DayWeather.allDaysWeather.count - 1
        }
        
        if(DayWeather.allDaysWeather.count != 0) {
            if let unwrappedWeatherStateAbbr = DayWeather.allDaysWeather[self.numberOfDay].weatherStateAbbr {
                let image = try? UIImage(data: Data(contentsOf: URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(unwrappedWeatherStateAbbr).png")!))
                if let unwrappedImage = image {
                    imageView.image = unwrappedImage
                }
            }
            
            let noDataString = "no data"
            self.dateLabel.text = DayWeather.allDaysWeather[self.numberOfDay].applicableDate
            self.weatherStateLabel.text = DayWeather.allDaysWeather[self.numberOfDay].weatherStateName
            if let unwrappedMinTemp = DayWeather.allDaysWeather[self.numberOfDay].minTemp {
                self.minTempLabel.text = "\(Int(unwrappedMinTemp)) °C"
            } else {
                self.minTempLabel.text = noDataString
            }
            if let unwrappedMaxTemp = DayWeather.allDaysWeather[self.numberOfDay].maxTemp {
                self.maxTempLabel.text = "\(Int(unwrappedMaxTemp)) °C"
            } else {
                self.maxTempLabel.text = noDataString
            }
            if let unwrappedWindSpeed = DayWeather.allDaysWeather[self.numberOfDay].windSpeed {
                self.windSpeedLabel.text = "\(String(format: "%.2f", unwrappedWindSpeed)) mph"
            } else {
                self.windSpeedLabel.text = noDataString
            }
            if let unwrappedWindDirection = DayWeather.allDaysWeather[self.numberOfDay].windDirection {
                self.windDirectionLabel.text = "\(String(format: "%.2f", unwrappedWindDirection)) °"
            } else {
                self.windDirectionLabel.text = noDataString
            }
            if let unwrappedAirPressure = DayWeather.allDaysWeather[self.numberOfDay].airPressure {
                self.airPressureLabel.text = "\(String(format: "%.2f", unwrappedAirPressure)) hPa"
            } else {
                self.windSpeedLabel.text = noDataString
            }
            if let unwrappedHumidity = DayWeather.allDaysWeather[self.numberOfDay].humidity {
                self.humidityLabel.text = "\(unwrappedHumidity) %"
            } else {
                self.humidityLabel.text = noDataString
            }
        }
    }
    
    @IBAction func clickPreviousButton(_ sender: Any) {
        self.numberOfDay -= 1
        if(self.numberOfDay == 0) {
            self.previousButtonShouldBeEnabled = false
        }
        self.nextButtonShouldBeEnabled = true
        DispatchQueue.main.async {
            self.viewWillAppear(true)
        }
    }
    
    @IBAction func clickNextButton(_ sender: Any) {
        self.numberOfDay += 1
        if(self.numberOfDay == DayWeather.allDaysWeather.count - 1) {
            self.nextButtonShouldBeEnabled = false
        }
        self.previousButtonShouldBeEnabled = true
        DispatchQueue.main.async {
            self.viewWillAppear(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DispatchQueue.main.async {
            self.titleLabel.textAlignment = .center
        }
        
        let urlString = URL(string: "https://www.metaweather.com/api/location/44418/")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.titleLabel.text = "ERROR OCCURED"
                    }
                } else {
                    if let usableData = data {
                        let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                        DayWeather(json: json as! [String: Any])
                        DispatchQueue.main.async {
                            self.viewWillAppear(true)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

