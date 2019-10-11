//
//  DressCombination.swift
//  Dress Coordinator
//
//  Created by Jingyu Cai on 3/5/18.
//  Copyright © 2018 Jingyu Cai. All rights reserved.
//

import Foundation
import UIKit

class DressCombination {
    
    var shirts = ["Black", "Yellow", "Blue", "Pink", "White"]
    var ties = ["Blue", "Navy Blue", "Yellow", "Pink", "Red", "Green"]
    var pants = ["White", "Khaki", "Green"]
    var shoes = ["Black", "Khaki"]
    var blazers = ["Navy Blue (Solid)", "Navy Blue (Grid)"]
    
    var shirtsArray = [UIImage(named: "shirt_black"), UIImage(named: "shirt_blue"), UIImage(named: "shirt_pink"), UIImage(named: "shirt_white"), UIImage(named: "shirt_yellow")]
    var tiesArray = [UIImage(named: "tie_blue"), UIImage(named: "tie_navyBlue"), UIImage(named: "tie_yellow"), UIImage(named: "tie_pink"), UIImage(named: "tie_red"), UIImage(named: "tie_green")]
    var pantsArray = [UIImage(named: "pants_white"), UIImage(named: "pants_khaki"), UIImage(named: "pants_green")]
    var shoesArray = [UIImage(named: "shoes_black"), UIImage(named: "shoes_khaki")]
    var blazersArray = [UIImage(named: "blazer_navyBlueSolid"), UIImage(named: "blazer_navyBlueGrid")]
}
