//
//  ViewController.swift
//  API Demo
//
//  Created by Emre Durukan on 4.12.2018.
//  Copyright © 2018 Emre Durukan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var descriptionText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getWeather(_ sender: Any) {
        let cityName = cityText.text!.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=" + cityName + "&appid=b9f1ad85305c2501d3b048b721e79846") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let urlContent = data {
                        
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                                DispatchQueue.main.sync(execute: {
                                    self.descriptionText.text = description
                                })
                                print(description)
                            }
                        } catch {
                            print("Json error")
                        }
                        
                    }
                }
            }
            task.resume()
        } else {
            self.descriptionText.text = "Couldn't find weather for that city."
        }
    }
    
}

