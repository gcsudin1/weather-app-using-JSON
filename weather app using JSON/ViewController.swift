//
//  ViewController.swift
//  weather app using JSON
//
//  Created by IMCS2 on 8/5/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBAction func checkWeather(_ sender: Any) {
        let cityNameURL = "http://api.openweathermap.org/data/2.5/weather?q=" + myTextField.text! + ",us&appid=88aaee13d46787a563b0888b30e4c419"
        let urlString = cityNameURL.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!){(data,response,error) in
            if error == nil{
                if let unwrappedData = data{
                    let dataString = String(data: unwrappedData, encoding: .utf8)
                    if dataString!.contains("city not found"){
                        DispatchQueue.main.async {
                            self.textView.text = "Invalid city name"
                        }
                    }else{
                        do{
                            let jsonResult = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                            let weather = jsonResult?["weather"] as? NSArray
                            let weatherItem = weather?[0] as? NSDictionary
                            let description = weatherItem?["description"] as! String
                            DispatchQueue.main.async {
                                self.textView.text = description
                            }
                        } catch{
                            self.textView.text = "Invalid City Name"
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(named:"weather.jpg")
        view.backgroundColor = UIColor(patternImage: img!)
    }
}


