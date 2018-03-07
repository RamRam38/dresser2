//
//  Weather.swift
//  Dress Coordinator
//
//  Created by Jingyu Cai on 3/5/18.
//  Copyright © 2018 Jingyu Cai. All rights reserved.
//

import Foundation

struct Weather {
    let temperature:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let temperature = json["temperature"] as? Double else {throw SerializationError.missing("N/A")}
        
        self.temperature = temperature
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/b7e50c7b5a10a0d38ff28f231dc40bdb/"
    
    static func currentWeather (withLocation location:String, completion: @escaping ([Weather]) -> ()) {
        
        let url = basePath + location
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var weatherArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let currentWeather = json["currently"] as? [String:Any] {
                            if let weatherObjects = try? Weather(json: currentWeather ) {
                                weatherArray.append(weatherObjects)
                            }
                        }
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(weatherArray)
                
            }
            
            
        }
        
        task.resume()
        
    }
    
    
}
