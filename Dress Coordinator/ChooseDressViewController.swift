//
//  ChooseDressViewController.swift
//  Dress Coordinator
//
//  Created by Jingyu Cai on 3/2/18.
//  Copyright © 2018 Jingyu Cai. All rights reserved.
//

import UIKit
import CoreLocation

class ChooseDressViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var shirtsLabel: UILabel!
    @IBOutlet weak var tiesLabel: UILabel!
    @IBOutlet weak var pantsLabel: UILabel!
    @IBOutlet weak var shoesLabel: UILabel!
    @IBOutlet weak var blazersLabel: UILabel!
    @IBOutlet weak var dayDateLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var weatherBtn: UIButton!
    
    @IBOutlet weak var dressCollectionView: UICollectionView!
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 375, height: 30))
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    let dressCombo = DressCombination()
    let classSchl = ClassSchedule()
    
    var cityName: String?
    
    var dressArray = [UIImage()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // updateWeather()
        
        chooseBtn.backgroundColor = .black
        chooseBtn.layer.cornerRadius = 25
        chooseBtn.layer.borderWidth = 2
        chooseBtn.layer.borderColor = UIColor.black.cgColor
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        let formattedDay = Date().dayOfWeek()!
        let formattedDateAbb = formatter.string(from: currentDate).capitalized
        dayDateLabel.text = "\(String(describing: formattedDay)), \(String(describing: formattedDateAbb))"

        switch formattedDay {
        case "Sunday": scheduleLabel.text = "Enjoy your weekend!"
        case "Monday": scheduleLabel.text = "Your first period is \(String(describing: classSchl.schedule["A"]!)) (A)"
        case "Tuesday": scheduleLabel.text = "Your first period is \(String(describing: classSchl.schedule["C"]!)) (C)"
        case "Wednesday": scheduleLabel.text = "Your first period is \(String(describing: classSchl.schedule["D"]!)) (D)"
        case "Thursday": scheduleLabel.text = "Your first period is \(String(describing: classSchl.schedule["G"]!)) (G)"
        case "Friday": scheduleLabel.text = "Your first period is \(String(describing: classSchl.schedule["F"]!)) (F)"
        case "Saturday": scheduleLabel.text = "Enjoy your weekend!"
        default: break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeather() {
        locationManager.delegate = self
        currentLocation = locationManager.location!
        
        // Get city name by (latitude, longitude) coordinates
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            if let city = addressDict["City"] as? String {
                self.cityName = city
            }
        })
        
        // Update UI from Dark Sky API
        Weather.currentWeather(withLocation: "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)") { (results:[Weather]) in
            for result in results {
                let celsiusResult = round(10 * (result.temperature - 32)/1.8)/10
                if let unwrappedCity = self.cityName {
                    self.weatherBtn.titleLabel?.text = "\(String(describing: unwrappedCity)): \(celsiusResult)°C"
                }
            }
        }

    }
    
    @IBAction func chooseDress(_ sender: UIButton) {
        dressArray.removeAll()
        
        let randomShirtsGen = Int(arc4random_uniform(UInt32(dressCombo.shirts.count)))
        shirtsLabel.text = dressCombo.shirts[randomShirtsGen]
        let randomPantsGen = Int(arc4random_uniform(UInt32(dressCombo.pants.count)))
        pantsLabel.text = dressCombo.pants[randomPantsGen]
        let randomBlazersGen = Int(arc4random_uniform(UInt32(dressCombo.blazers.count)))
        blazersLabel.text = dressCombo.blazers[randomBlazersGen]
        let randomTieGen = Int(arc4random_uniform(UInt32(dressCombo.ties.count)))
        tiesLabel.text = dressCombo.ties[randomTieGen]
        let randomShoeGen = Int(arc4random_uniform(UInt32(dressCombo.shoes.count)))
        shoesLabel.text = dressCombo.shoes[randomShoeGen]
        
        // Update dressArray for images
        dressArray.append(dressCombo.shirtsArray[randomShirtsGen]!)
        dressArray.append(dressCombo.tiesArray[randomTieGen]!)
        dressArray.append(dressCombo.pantsArray[randomPantsGen]!)
        dressArray.append(dressCombo.blazersArray[randomBlazersGen]!)
        dressArray.append(dressCombo.shoesArray[randomShoeGen]!)
        
        label.removeFromSuperview()
        dressCollectionView.reloadData()
        
        // Constraints for color choosing based on shirts choice first
        // Not executed
        switch dressCombo.shirts[randomShirtsGen] {
        case "Black":
            // Black shirts cannot pair w/ navy blue or yellow tie
            let noBlackYellowTies = dressCombo.ties.filter { $0 != "Navy Blue" && $0 != "Yellow" }
            let randomNoBlackYellowTiesGen = Int(arc4random_uniform(UInt32(noBlackYellowTies.count)))
            // tiesLabel.text = noBlackYellowTies[randomNoBlackYellowTiesGen]
        case "Yellow":
            // Yellow shirt can only go with the following
            // tiesLabel.text = "Navy Blue"
            // shoesLabel.text = "Khaki"
            // blazersLabel.text = "Navy Blue(Solid)"
            // Yellow shirts cannot pair w/ green pants
            let noGreenPants = dressCombo.pants.filter { $0 != "Green"}
            let randomNoGreenPantsGen = Int(arc4random_uniform(UInt32(noGreenPants.count)))
            // pantsLabel.text = noGreenPants[randomNoGreenPantsGen]
        case "Blue":
            // Blue shirts cannot pair w/ blue, pink or yellow tie
            let noBluePinkYellowTies = dressCombo.ties.filter { $0 != "Blue" && $0 != "Pink" && $0 != "Green" }
            let randomNoBluePinkYellowTiesGen = Int(arc4random_uniform(UInt32(noBluePinkYellowTies.count)))
            // tiesLabel.text = noBluePinkYellowTies[randomNoBluePinkYellowTiesGen]
        case "Pink":
            // Pink shirt can only go with white pants
            // pantsLabel.text = "White"
            // Pink shirts cannot pair w/ blue, yellow, red and green ties
            let noBlueYellowRedGreenTies = dressCombo.ties.filter { $0 != "Blue" && $0 != "Yellow" && $0 != "Red" && $0 != "Green"}
            let randomNoBlueYellowRedGreenTiesGen = Int(arc4random_uniform(UInt32(noBlueYellowRedGreenTies.count)))
            // tiesLabel.text = noBlueYellowRedGreenTies[randomNoBlueYellowRedGreenTiesGen]
        case "White":
            // White shirts cannot go with pink ties
            let noPinkTies = dressCombo.ties.filter { $0 != "Pink"}
            let randomNoPinkTiesGen = Int(arc4random_uniform(UInt32(noPinkTies.count)))
            // tiesLabel.text = noPinkTies[randomNoPinkTiesGen]
        default: break
        }
        
        // Constraints for color choosing based on pants choice first
        // Not executed
        switch dressCombo.pants[randomPantsGen] {
        // White and yellow pants can only go with khaki shoes
        case "White":
            // shoesLabel.text = "Khaki"
            break
        case "Khaki":
            // shoesLabel.text = "Khaki"
            break
        // Green pants can only go with black shoes
        case "Green":
            // shoesLabel.text = "Black"
            break
        default: break
        }
 
    }
    
    @IBAction func updateWeather(_ sender: UIButton) {
        // updateWeather()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dressCombo.shirtsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        if dressArray.count != 5 {
            label.center = CGPoint(x: self.view.frame.width/2, y: 285)
            label.textAlignment = .center
            label.font = UIFont(name: "Hoefler Text", size: 19)
            label.text = "Press Choose for a fresh new look"
            self.view.addSubview(label)
        } else {
            cell.dressImg.image = dressArray[indexPath.row]
        }
        return cell
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
