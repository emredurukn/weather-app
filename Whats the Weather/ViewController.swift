//
//  ViewController.swift
//  Whats the Weather
//
//  Created by Emre Durukan on 25.11.2018.
//  Copyright © 2018 Emre Durukan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func getWeather(_ sender: Any) {
        var message = ""
        var city = ""
        if cityTextField.text!.last == " " {
            let length = cityTextField.text!.count - 1
            city = NSString(string: cityTextField.text!).substring(with: NSRange(location: 0, length: length))
        }
        city = city.replacingOccurrences(of: " ", with: "-")
        
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + city + "/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                if let error = error {
                    print(error)
                } else {
                    if let unwarappedData = data {
                        let dataString = NSString(data: unwarappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeparator = "(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            if contentArray.count > 1 {
                                stringSeparator = "</span></p></td><td class="
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                }
                            }
                        }
                    }
                }
                if message == "" {
                    message = "The weather there couldn't be found. Please try again."
                }
                
                DispatchQueue.main.sync(execute: {
                    self.resultLabel.text = message
                })
            }
            task.resume()
        } else {
            resultLabel.text = "The weather there couldn't be found. Please try again."
        }
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

