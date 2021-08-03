//
//  SignUpVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 13/04/2021.
//

import UIKit
import Alamofire
class SignUpVC: UIViewController, Location {
   
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var changeLocationView: UIView!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var signUpBtnn: UIStackView!
    var isValidName = false
    var isValidLoc = false
    var isValidPhone = false
    var isValidPass = false
    var isValidEmail = false
    
    
    func setLocation(loc: ItemLocation) {
        selectedLoc = loc
        locationLbl.text = loc.name
        isValidLoc = true
        validation()
    }
    var selectedLoc : ItemLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        changeLocationView.addGestureRecognizer(tap)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.navigationController?.navigationBar.isHidden = false
        let vc = DropPinVC.instantiate(type: .Profile) as! DropPinVC
        vc.location = self
        pushVC(vc)
    }
    @IBAction func signupBtnTapped(_ sender: Any) {
        signupAPiCall()
    }
    func signupAPiCall() {
        self.startActivityIndicator()
        let param = [
            "trn":"",
            "password":passTF.text!,
            "phone":phoneTF.text!,
            "re_password":passTF.text!,
            "module":"add_customer",
            "name":nameTF.text!,
            "from":"app",
            "username":emailTF.text!,
            "customer_address": selectedLoc!.name,
            "customer_address_lat": selectedLoc!.lat,
            "customer_address_lng": selectedLoc!.long,
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
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        if let window = UIApplication.shared.windows.first {
            let vc = LoginVC.instantiate(type: .Profile)
            window.rootViewController = vc
        }
    }
    
    @IBAction func textFieldChange(_ sender: UITextField) {
        switch sender {
        case nameTF:
            if nameTF.text!.isValidName {
                isValidName = true
            }else {
                isValidName = false
            }
        case emailTF:
            if emailTF.text!.isValidEmail() {
                isValidEmail = true
            }else {
                isValidEmail = false
            }
        case phoneTF:
            if phoneTF.text!.isNotEmpty() {
                isValidPhone = true
            }else {
                isValidPhone = false
            }
        case passTF:
            if passTF.text!.count > 5 {
                isValidPass = true
            }else {
                isValidPass = false
            }
            
        default:
            break
        }
        validation()
    }
    func  validation()  {
        if isValidPhone &&  isValidName && isValidEmail && isValidPass && isValidLoc {
            signUpBtnn.isUserInteractionEnabled = true
        }else {
            signUpBtnn.isUserInteractionEnabled = false
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
