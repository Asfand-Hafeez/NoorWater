//
//  ChangePasswordVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 25/04/2021.
//

import UIKit
import Alamofire
class ChangePasswordVC: UIViewController {
    @IBOutlet weak var confirmPassTF: UITextField!
    
    @IBOutlet weak var updatePassBtn: UIButton!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var email = ""
    var isValidPass = false
    var isValidConfirmPass = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
    }
    
    @IBAction func textFieldChange(_ sender: UITextField) {
        switch sender {
        case passwordTF:
            if passwordTF.text!.count > 4 {
                isValidPass = true
            }else {
                isValidPass = false
            }
        case confirmPassTF:
            if confirmPassTF.text == passwordTF.text {
                isValidConfirmPass = true
            }else {
                isValidConfirmPass = false
            }
        default:
            break
        }
        validation()
    }

    func validation()  {
        if isValidPass && isValidConfirmPass {
            updatePassBtn.isUserInteractionEnabled = true
        }else {
            updatePassBtn.isUserInteractionEnabled = false
        }
    }
  @IBAction func updatePasswordBtnTapped() {
    
    changePassCall()
    }
    func changePassCall() {
        self.startActivityIndicator()
        let param = [
            "code":codeTF.text!,
            "password":passwordTF.text!,
            "re_password":confirmPassTF.text!,
            "module":"password_update",
            "from":"app",
            "email": email
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
                        
                        ApiService.instance.setLoginRootVC()
                        
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
