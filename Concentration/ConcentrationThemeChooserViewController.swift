//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by sunsetwan on 2019/4/5.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals": "🐶🦆🐹🐸🐘🦍🐓🐩🐦🦋🐙🐏",
        "Faces": "😀😌😎🤓😠😤😭😰😱😳😜😇"
    ]

    // Why do we need performSegue mannually instead of ctrl-dragging in storyboard?
    // Because someone may want conditional segueing.
    @IBAction func changeTheme(_ sender: Any) {
        // how to find a splitView
        if let cvc = splitDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            // how to hold something in the heap that gets thrown off of a navigation stack
        }else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            // how to push things on a navigation stack without segueing
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            // how to segue from code
                performSegue(withIdentifier: "Choose Theme", sender: sender)
            }

        
    }
    
    // On an non-Plus iPhone, there isn't a splitViewController.
    private var splitDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    // MARK: - Navigation
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    // It's crucial to understand that this preparation is happening BEFORE outlets get set!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }

    
    
 

}
