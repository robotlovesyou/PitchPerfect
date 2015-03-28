//
//  NavigationController.swift
//  Pitch Perfect
//
//  Created by ANDREW SMITH on 08/03/2015.
//  Copyright (c) 2015 Robot Loves You. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        
        var nav = self.navigationBar
        // This color (and subsequent font) should be set in a central source
        // but this is the only place they are set so it's not such a big deal
        let color = UIColor(red: 0.145, green: 0.282, blue: 0.431, alpha: 1.0)
        
        // Set the background color for the bar
        nav.barTintColor = UIColor.whiteColor()
        
        // Set the color for the back chevron
        nav.tintColor = color
        
        if let font = UIFont(name: "STHeitiSC-Light", size: 20.0){
            nav.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
        }
    }
}
