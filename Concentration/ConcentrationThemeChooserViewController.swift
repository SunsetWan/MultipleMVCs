//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by sunsetwan on 2019/4/5.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate{

    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals": "🐶🦆🐹🐸🐘🦍🐓🐩🐦🦋🐙🐏",
        "Faces": "😀😌😎🤓😠😤😭😰😱😳😜😇"
    ]

    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    // There is a little bit of advanced use of delegation.
    // To prevent this from happening, we need to set 'True'
    // If this method returns 'False', you're basically saying I did not collapse this for you, so you do it.
    // If concentration game has a nil theme, then theme has never been set, we don't want to do that collapse
    func splitViewController(
        _ splitViewController: UISplitViewController,
         collapseSecondary secondaryViewController: UIViewController,
         onto primaryViewController: UIViewController
        ) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return  false
    }
    
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
    
    // On an non-Plus iPhone, a splitViewController doesn't show directly.
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
