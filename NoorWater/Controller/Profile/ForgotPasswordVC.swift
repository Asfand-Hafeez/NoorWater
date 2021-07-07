//
//  ForgotPasswordVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 25/04/2021.
//

import UIKit
import Alamofire
class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    var isValidEmail = false
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func textFieldChange(_ sender: UITextField) {
        if emailTF.text!.isValidEmail() {
            isValidEmail = true
        }else {
            isValidEmail = false
        }
        validation()
    }
    func validation()  {
        if isValidEmail {
            nextBtn.isUserInteractionEnabled = true
        }else {
            nextBtn.isUserInteractionEnabled = false
        }
    }
    @IBAction func nextBtnTapped() {
        urlsession()
      }
    func urlsession()  {
        self.startActivityIndicator()
        let param  = [
            "module":"forget_password",
            "from":"app",
            "email":emailTF.text!
        ] as [String: Any]
        
        AF.request( "\(BASE_URL)process", method: .post, parameters: param).response { response in
            debugPrint(response)
            if let data = response.data{
                print(data.prettyPrintedJSONString ?? "no data")
                                
                do {
                    
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonPetitions = try decoder.decode(UserModel.self, from: data)
                    if jsonPetitions.result == "true" {
                        let vc = ChangePasswordVC.instantiate(type: .Profile) as! ChangePasswordVC
                        vc.email = self.emailTF.text!
                        self.pushVC(vc)
                        
                    }else {
                        self.showAlert(text: jsonPetitions.msg!)
                    }
                   
                   
                    
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
       

    }
}
