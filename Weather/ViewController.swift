//
//  ViewController.swift
//  Weather
//
//  Created by un1kalny on 13/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            if(DayWeather.allDaysWeather.count != 0) {
                let noDataString = "no data"
                self.dateLabel.text = DayWeather.allDaysWeather[self.numberOfDay].applicableDate
                self.weatherStateLabel.text = DayWeather.allDaysWeather[self.numberOfDay].weatherStateName
                if let unwrappedMinTemp = DayWeather.allDaysWeather[self.numberOfDay].minTemp {
                    self.minTempLabel.text = "\(unwrappedMinTemp)"
                } else {
                    self.minTempLabel.text = noDataString
                }
                if let unwrappedMaxTemp = DayWeather.allDaysWeather[self.numberOfDay].maxTemp {
                    self.maxTempLabel.text = "\(unwrappedMaxTemp)"
                } else {
                    self.maxTempLabel.text = noDataString
                }
                if let unwrappedWindSpeed = DayWeather.allDaysWeather[self.numberOfDay].windSpeed {
                    self.windSpeedLabel.text = "\(unwrappedWindSpeed)"
                } else {
                    self.windSpeedLabel.text = noDataString
                }
                if let unwrappedWindDirection = DayWeather.allDaysWeather[self.numberOfDay].windDirection {
                    self.windDirectionLabel.text = "\(unwrappedWindDirection)"
                } else {
                    self.windDirectionLabel.text = noDataString
                }
                if let unwrappedAirPressure = DayWeather.allDaysWeather[self.numberOfDay].airPressure {
                    self.airPressureLabel.text = "\(unwrappedAirPressure)"
                } else {
                    self.windSpeedLabel.text = noDataString
                }
                if let unwrappedHumidity = DayWeather.allDaysWeather[self.numberOfDay].humidity {
                    self.humidityLabel.text = "\(unwrappedHumidity)"
                } else {
                    self.humidityLabel.text = noDataString
                }
            }
        }
    }
    
    @IBAction func clickPreviousButton(_ sender: Any) {
        if(self.numberOfDay == 0) {
            self.previousButton.isHidden = true
            return
        }
        self.numberOfDay -= 1
        self.nextButton.isHidden = false
        viewWillAppear(true)
    }
    
    @IBAction func clickNextButton(_ sender: Any) {
        if(self.numberOfDay == DayWeather.allDaysWeather.count - 1) {
            self.nextButton.isHidden = true
        }
        self.numberOfDay += 1
        self.previousButton.isHidden = false
        viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        titleLabel.text = "Weather - Kacper Szalwa"
        titleLabel.textAlignment = .center
        
        let urlString = URL(string: "https://www.metaweather.com/api/location/44418/")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        //print(usableData)
                        //print(response)
                        let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                        //print(json)
                        DayWeather(json: json as! [String: Any])
                        self.viewWillAppear(true)
                        //for day in DayWeather.allDaysWeather {
                          //  print(day)
                        
                       // }
                        
                    }
                }
            }
            task.resume()
        }
    }
}

