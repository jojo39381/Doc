//
//  DiseaseResult.swift
//  iDoc
//
//  Created by Joseph Yeh on 3/24/18.
//  Copyright © 2018 Joseph Yeh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ChameleonFramework
class DiseaseController: UIViewController {
    @IBOutlet weak var warning: UILabel!

    @IBAction func startAgain(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    var searchFor = ""
      var status = "a"
    let params = ["":""]
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Diagnoses"
        disease.text = searchFor
        switch status {
        case "emergency":warning.text = "This is an \(status)"
        warning.backgroundColor = UIColor.flatRed()
        case "self_care":warning.text = "Self care is adviced"
        warning.backgroundColor = UIColor.flatYellow()
        case "consultation":warning.text = "You should visit your doctor"
        warning.backgroundColor = UIColor.flatOrange()
        default:
            print("bro")
        }

        let new = searchFor.replacingOccurrences(of: " ", with: "%20")
        let url =  "https://en.wikipedia.org/w/api.php?action=opensearch&search=\(new)&limit=1&namespace=0&format=json"
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {

           self.warning.alpha = 0
        }, completion: nil)




        fetchSummary(url: url, parameters: params)

    }
    @IBOutlet weak var disease: UILabel!
    @IBOutlet weak var summary: UILabel!
    

    func fetchSummary(url : String, parameters: [String : Any]) {

        Alamofire.request(url, method:.get, parameters: parameters).responseJSON {

            response in
            if response.result.isSuccess {
                print("Success!")
                let forecastData : JSON = JSON(response.result.value!)
                print(forecastData)
                self.update(json:forecastData)

            }
            else {
                print("Error \(String(describing: response.result.error))")

            }
        }

    }

        func update(json:JSON) {
            let titles = json[1][0].stringValue

            let new = titles.replacingOccurrences(of: " ", with: "_")
             print(new)
    let url = "https://en.wikipedia.org/api/rest_v1/page/summary/\(new)"

            fetchArticle(url: url)
        }

        func fetchArticle(url : String) {

            Alamofire.request(url, method:.get).responseJSON {

                response in
                if response.result.isSuccess {
                    print("Success!")
                    let forecastData : JSON = JSON(response.result.value!)
                    print(forecastData)
                    self.updateUI(json:forecastData)
                }
                else {
                    print("Error \(String(describing: response.result.error))")
                }
            }
}
    func updateUI(json:JSON) {
        let summaryText = json["extract"].stringValue
        summary.text = summaryText
    }





















    


}
