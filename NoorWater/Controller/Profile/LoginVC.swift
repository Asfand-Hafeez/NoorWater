//
//  LoginVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 13/04/2021.
//

import UIKit
import Alamofire
import KYDrawerController
class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var signBtn: UIButton!
    var isValidEmail = false
    var isValidPass = false
    let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
    override func viewDidLoad() {
        super.viewDidLoad()

        transparentNavBar()
    }
    
    @IBAction func remeberMeBtnTapped(_ sender: Any) {
    }
    @IBAction func forgotPassBtnTapped(_ sender: Any) {
        let vc = ForgotPasswordVC.instantiate(type: .Profile)
        pushVC(vc)
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        urlsession()
        
    }
    
    
    func urlsession()  {
        self.startActivityIndicator()
        let param  = [
            "password":passTF.text!,
            "for":"customer",
            "from":"app",
            "username":emailTF.text!,
            "token":"121212"
        ] as [String: Any]
        
        AF.request( "\(BASE_URL)login/login_exec", method: .post, parameters: param).response { response in
            debugPrint(response)
            if let data = response.data{
                print(data.prettyPrintedJSONString ?? "no data")
                                
                do {
                    
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonPetitions = try decoder.decode(UserModel.self, from: data)
                    if jsonPetitions.result == "true" {
                        if let json = jsonPetitions.userDetails {
                        ApiService.instance.saveUserToDefaults(user: json)
                            ApiService.instance.setDashBoardRootVC()
                        }
                        
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
    @IBAction func skipBtnTapped(_ sender: Any) {
        ApiService.instance.setDashBoardRootVC()
    }
    @IBAction func textFieldChange(_ sender: UITextField) {
        switch sender {
        case emailTF:
            if emailTF.text!.isValidEmail() {
               isValidEmail = true
            }else {
                isValidEmail = false
            }
        case passTF:
            if passTF.text!.count > 4 {
                isValidPass = true
            }else {
                isValidPass = false
            }
        default:
            break
        }
        validation()
        
    }
    func validation() {
        if isValidPass && isValidPass {
            signBtn.isUserInteractionEnabled = true
            
        }else {
            signBtn.isUserInteractionEnabled = false
        }
    }
    @IBAction func registerBtnTapped(_ sender: Any) {
        if let window = UIApplication.shared.windows.first {
            let vc = UINavigationController(rootViewController: SignUpVC.instantiate(type: .Profile))
            window.rootViewController = vc
        }
    }
   

}
