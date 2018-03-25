//
//  SecondViewController.swift
//  iDoc
//
//  Created by Joseph Yeh on 3/24/18.
//  Copyright © 2018 Joseph Yeh. All rights reserved.
//

import UIKit
import ChameleonFramework
class SecondViewController: UIViewController {
   var gender = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Initial"
        // Do any additional setup after loading the view.
    }



    @IBOutlet weak var femaleButton: UIButton!

    @IBOutlet weak var maleButton: UIButton!

    @IBAction func maleAction(_ sender: Any) {


        maleButton.setBackgroundColor(color: UIColor.flatRed(), forState:.normal)
        femaleButton.setBackgroundColor(color: view.backgroundColor!, forState:.normal)

        gender = "male"
    }
    @IBAction func femaleAction(_ sender: Any) {

        femaleButton.setBackgroundColor(color: UIColor.flatRed(), forState:.normal)

            maleButton.setBackgroundColor(color: view.backgroundColor!, forState:.normal)

        gender = "female"

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {
            let vc = segue.destination as! FirstViewController
            print(gender)
            vc.gender = gender

           
        }

    }


}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(colorImage, for: forState)
    }}
