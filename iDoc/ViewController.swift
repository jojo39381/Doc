//
//  ViewController.swift
//  iDoc
//
//  Created by Joseph Yeh on 3/22/18.
//  Copyright © 2018 Joseph Yeh. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import ChameleonFramework
import ProgressHUD
class ViewController: UIViewController {
    var triage = "asdjla"
    var alarming = ""
    @IBOutlet weak var buttonYes: UIButton!
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var buttonDontKnow: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    var url = "https://api.infermedica.com/v2/diagnosis"
    var processURL = "https://api.infermedica.com/v2/parse"
  
    var NLP:NLPmodel?

    var params = Parameters()
    let headers = ["App-Id": "2dd5bc4d" , "App-Key": "89299460ef8b61f93a6d90b161928184", "Content-Type": "application/json"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Interview"
        print(NLP?.NLPsymptoms)
        params =
            [   "sex": "\(sex)",
                "age": age,
                "evidence": NLP!.NLPsymptoms
        ]
        print(params)
         fetchDiagnoses(url: url, parameters: params)

        // Do any additional setup after loading the view, typically from a nib.
    }
    func fetchDiagnoses(url : String, parameters: Parameters) {

        Alamofire.request(url, method:.post, parameters:parameters, encoding: JSONEncoding.default, headers:headers).responseJSON {

            response in
            if response.result.isSuccess {
                print("Success")
                let forecastData : JSON = JSON(response.result.value!)
                print(forecastData)
                self.updateQuestion(json: forecastData)

            }
            else {
                print("Error \(String(describing: response.result.error))")
                
            }
        }
        

}

    var age = 0
    var sex = "male"

var questionsModel = QuestionsModel()
    func updateQuestion(json:JSON) {
        questionsModel = QuestionsModel()
        if json["should_stop"].boolValue == false {
        let question = json["question"]["text"].stringValue
        questionsModel.question = question

        switch json["question"]["type"].stringValue{

            case "single":
                questionState = "single"
                  for i in 0...2 {
                    questionsModel.choices.append(json["question"]["items"][0]["choices"][i]["label"].stringValue)
 questionsModel.id.append(json["question"]["items"][i]["id"].stringValue)
                  }
        case "group_single":
            questionState = "group_single"
            for i in 0...3 {
                questionsModel.choices.append(json["question"]["items"][i]["name"].stringValue)
                 questionsModel.id.append(json["question"]["items"][i]["id"].stringValue)
            }
            print(json["question"]["items"]["name"].count)
        case "group_multiple":
             questionState = "group_multiple"
            for i in 0...5 {
                questionsModel.choices.append(json["question"]["items"][i]["name"].stringValue)
                questionsModel.id.append(json["question"]["items"][i]["id"].stringValue)
            }
             

        default:
            print("defalut")
        }


setUp()
        }
        else {
            disease = json["conditions"][0]["common_name"].stringValue
            let url = "https://api.infermedica.com/v2/triage"
            fetch(url:url, parameters:params)


        }
}
    var disease = ""
    func ended() {

performSegue(withIdentifier: "goToResults", sender: self)
    }
    func setUp() {
        buttonDontKnow.isHidden = false
        questionLabel.text = questionsModel.question

        buttonYes.setTitle(questionsModel.choices[0], for: .normal)
        buttonNo.setTitle(questionsModel.choices[1], for: .normal)
        buttonDontKnow.setTitle(questionsModel.choices[2], for: .normal)
        if buttonDontKnow.titleLabel?.text == nil {
            buttonDontKnow.isHidden = true
        }
    }
    
   
    @IBAction func button1(_ sender: Any) {
combine(number: 0)


    }
    @IBAction func button2(_ sender: Any) {
combine(number: 1)
    }
    @IBAction func button3(_ sender: Any) {
       combine(number: 2)
    }

    var questionState = ""
    func combine(number:Int) {
        if questionsModel.choices[1] == "No" {
            questionsModel.choices[1] = "absent"
        }
        else {
            questionsModel.choices[1] = "present"
        }
        if questionsModel.choices[2] == "Don't Know" {
             questionsModel.choices[2] = "unknown"
        }
        else {
             questionsModel.choices[2] = "present"
        }

        questionsModel.choices[0] = "present"
        switch questionState {
        case "single" :
        questionsModel.idDict = ["id":questionsModel.id[0],"choice_id":questionsModel.choices[0]]
        case "group_single":
       questionsModel.idDict = ["id":questionsModel.id[number],"choice_id":questionsModel.choices[number]]
        case "group_multiple":
            questionsModel.idDict = ["id":questionsModel.id[number],"choice_id":questionsModel.choices[number]]
        default:
            print("success")
        }
        
        NLP?.NLPsymptoms += [questionsModel.idDict]
         params =
            [   "sex": "\(sex)",
                "age": age,
                "evidence": NLP!.NLPsymptoms
        ]


        fetchDiagnoses(url : url, parameters: params)

    }





    func fetch(url : String, parameters: Parameters) {

        Alamofire.request(url, method:.post, parameters:parameters, encoding: JSONEncoding.default, headers:headers).responseJSON {
            
            response in
            if response.result.isSuccess {
                print("Success")
                let forecastData : JSON = JSON(response.result.value!)
                print(forecastData)
                self.lastResult(json: forecastData)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                
            }
        }
        
        
    }



    func lastResult(json:JSON) {
         triage = json["triage_level"].stringValue
        print(triage)
        for i in 0...10{
            alarming = json["serious"][i]["common_name"].stringValue}
        ended()
    }





















    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goToResults" {
            let vc = segue.destination as! DiseaseController
            print(triage)
            print(disease)
            vc.status = triage
            vc.searchFor = disease

        }
    }
    
    
}
