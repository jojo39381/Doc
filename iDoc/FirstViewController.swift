//
//  FirstViewController.swift
//  iDoc
//
//  Created by Joseph Yeh on 3/24/18.
//  Copyright © 2018 Joseph Yeh. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {



    @IBOutlet weak var ageOutlet: UILabel!
 
    

    @IBAction func ageChange(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        ageOutlet.text = "\(currentValue)"

    }
    
  
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goNext" {
            let vc = segue.destination as! ThirdViewController
            vc.gender = gender
            vc.age = Int(ageOutlet.text!)!
            
        }
        
    }
   

}
