//
//  NewPlacesViewController.swift
//  cocos
//
//  Created by MIGUEL on 7/08/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class NewPlacesViewController: BaseUIViewController {
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var nearMeButton: UIButton!
    @IBOutlet weak var benefitButton: UIButton!
    
    var containerView : ContainerViewController!
    var buttonSelected : PlacesButtonSelected = .category
    let kshowCategoryIdentifier : String = "showCategoryIdentifier"
    let kshowNearMeIdentifier : String = "showNearMeIdentifier"
    let kshowBenefitsIdentifier : String = "showBenefitsIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectButton(buttonSelected)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButtonDidSelect(_ sender: Any) {
        performSegue(withIdentifier: "showSearchIdentifier", sender: self)
    }
    
    @IBAction func categoryButtonDidSelect(_ sender: Any) {
        selectButton(PlacesButtonSelected.category)
    }
    
    @IBAction func nearMeButtonDidSelect(_ sender: Any) {
        selectButton(PlacesButtonSelected.nearMe)
    }
    
    @IBAction func benefitButtonDidSelect(_ sender: Any) {
        selectButton(PlacesButtonSelected.discount)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            containerView = segue.destination as! ContainerViewController
            containerView.animationDurationWithOptions = (0.2, .transitionCrossDissolve)
        }
    }
    
    fileprivate func changeColor(_ button : UIButton,_ type: Bool){
        if type {
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = button.bounds
            gradient.colors = [
                UIColor(red:255/255,green:255/255,blue:255/255,alpha:1).cgColor,
                UIColor(red:255/255,green:255/255,blue:255/255,alpha:1).cgColor,
                UIColor(red:0/255,green:0/255,blue:0/255,alpha:1).cgColor,
                UIColor(red:0/255,green:0/255,blue:0/255,alpha:1).cgColor
            ]
            
            /* repeat the central location to have solid colors */
            gradient.locations = [0, 0.9, 0.9, 1.0]
            
            /* make it vertical */
            gradient.startPoint = CGPoint(x:0.5,y: 0)
            gradient.endPoint = CGPoint(x:0.5,y: 1)
            
            button.layer.insertSublayer(gradient, at: 0)
        }
        else{
            if let layers = button.layer.sublayers{
                if layers.count>1{
                    layers[0].removeFromSuperlayer()
                }
            }
            button.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha:1)
        }
    }
    
    fileprivate func selectButton(_ typeButton : PlacesButtonSelected){
        switch typeButton {
        case .category:
            buttonSelected = PlacesButtonSelected.category
            changeColor(categoryButton, true)
            changeColor(nearMeButton, false)
            changeColor(benefitButton, false)
            containerView.segueIdentifierReceivedFromParent(kshowCategoryIdentifier)
            break
        case .nearMe:
            buttonSelected = PlacesButtonSelected.nearMe
            changeColor(categoryButton, false)
            changeColor(nearMeButton, true)
            changeColor(benefitButton, false)
            containerView.segueIdentifierReceivedFromParent(kshowNearMeIdentifier)
            break
        case .discount:
            buttonSelected = PlacesButtonSelected.discount
            changeColor(categoryButton, false)
            changeColor(nearMeButton, false)
            changeColor(benefitButton, true)
            containerView.segueIdentifierReceivedFromParent(kshowBenefitsIdentifier)
            break
        }
    }
}
