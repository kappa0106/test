//
//  ViewController.swift
//  test
//
//  Created by NDHU_CSIE on 2021/1/14.
//  Copyright © 2021 NDHU_CSIE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let API_URL = "https://api.openweathermap.org/data/2.5/weather?"
    private let ICON_URL = "https://openweathermap.org/img/wn/"
    private let API_KEY = "ae280ea1ca0ece398bb64bb28e4edd0c"
       
    @IBOutlet var name: UILabel!
    @IBOutlet var temp: UILabel!
    @IBOutlet var feel: UILabel!
    @IBOutlet var hum: UILabel!
    @IBOutlet var state: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getForecast(location: "Kaohsiung")
    }
    func getForecast(location: String) {
        
        guard let accessURL = URL(string: API_URL + "q=\(location)&units=metric&lang=zh_tw&APPID=\(API_KEY)") else { return  }
        let request = URLRequest(url: accessURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            //parse data
            if let data = data {
                let decoder = JSONDecoder()
                if let weatherData = try? decoder.decode(WeatherForecastData.self, from: data) {
                    //download weahter icon
                    self.getImage(weatherCode: weatherData.weather[0].icon)
                    let temp = weatherData.main.temp

                    let feel = weatherData.main.feels_like

                    OperationQueue.main.addOperation {
                        self.name.text = weatherData.name
                        self.temp.text = "溫度： " + String(format: "%.1f",temp) + "℃"
                        self.feel.text = "體感： " + String(format: "%.1f",feel) + "℃"
                        self.hum.text = "濕度： " + String(format: "%.1f", weatherData.main.humidity) + "%"
                        self.state.text = weatherData.weather[0].description
                    }
                }
            }
        })
        
        task.resume()
    }
    
    
    func getImage(weatherCode: String) {

        guard let accessURL = URL(string: ICON_URL + "\(weatherCode)@2x.png") else {
            return
        }

        let request = URLRequest(url: accessURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            //parse data
            if let data = data, let image = UIImage(data: data) {
                OperationQueue.main.addOperation {
                    self.weatherIcon.image = image
                }
            }
        })

        task.resume()
    }


}

