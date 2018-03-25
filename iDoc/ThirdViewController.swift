//
//  ThirdViewController.swift
//  iDoc
//
//  Created by Joseph Yeh on 3/25/18.
//  Copyright © 2018 Joseph Yeh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textfield: UITextField!
    @IBAction func enter(_ sender: Any) {
        let symptomsText = textfield.text!
        let textParams = ["text" : symptomsText]

        processor(url: processURL, parameters: textParams)
    }
    let NLP = NLPmodel()
    let headers = ["App-Id": "2dd5bc4d" , "App-Key": "89299460ef8b61f93a6d90b161928184", "Content-Type": "application/json"]

    func processor(url : String, parameters: Parameters) {
        Alamofire.request(url, method:.post, parameters:parameters, encoding: JSONEncoding.default, headers:headers).responseJSON {

            response in
            if response.result.isSuccess {
                print("Success")
                let forecastData : JSON = JSON(response.result.value!)
                print(forecastData)
                self.updateNLP(json:forecastData)

            }
            else {
                print("Error \(String(describing: response.result.error))")

            }
        }


    }





var gender = ""
var age = 0

var name = [String]()
    func updateNLP(json:JSON) {

        if json["mentions"].count > 0 {for i in 0...(json["mentions"].count-1) {
            let symID = json["mentions"][i]["id"].stringValue
            let choiceID = json["mentions"][i]["choice_id"].stringValue
            NLP.NLPsymptoms.append(["id":symID, "choice_id": choiceID, "initial": "true"])
            name.append(json["mentions"][i]["name"].stringValue)
        }
        }
        else {

        }
        tableView.reloadData()

    }











var processURL = "https://api.infermedica.com/v2/parse"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            let vc = segue.destination as! ViewController
            print(gender)
            print(age)
            vc.sex = gender
            vc.age = age
            vc.NLP = NLP

        }

    }






    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return name.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let firstCell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath) as! Cell
        if name.count > 0 {
            print(indexPath.row)
firstCell.textLabel!.text = name[indexPath.row]
firstCell.textLabel!.textColor = UIColor.flatMagenta()
        }
        else {

        }

        return firstCell
    }




 









}
