//
//  UpdateProfileVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 21/04/2021.
//

import UIKit
import KYDrawerController
import Alamofire
import SDWebImage
class UpdateProfileVC: UIViewController, GetBackDeliveryDays {
    
    

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var updatePasswordView: UIView!
    
    
    @IBOutlet weak var deliveryDaysView: UIView!
    @IBOutlet weak var updatePassBtn: UIButton!
    @IBOutlet weak var editImageICon: UIButton!
    
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var cPassTF: UITextField!
    @IBOutlet weak var deliveryDaysTF: UITextField!
    @IBOutlet weak var customerTypeTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    var imagePicker = UIImagePickerController()
    var customerTypePicker = UIPickerView()
    
    @IBOutlet weak var updatePassWordBtn: UIButton!
    var customeType = [String]()
    
    var deliveryDays = [String]()
    var days = [SelectDays]()
    var isValidPass = false
    var isValidConfirmPass = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePasswordView.isHidden = true
        title = "Profile"
        updatePassBtn.isHidden = true
        transparentNavBar()
        customerTypeTF.delegate = self
        
        setUpData()
        getCustomerTypeCall()
        customerTypePicker.delegate = self
        customerTypePicker.dataSource = self
        deliveryDaysTF.isUserInteractionEnabled = false
        
        customerTypeTF.inputView = customerTypePicker
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        deliveryDaysView.addGestureRecognizer(tap)
        
    }
    
    
    @IBAction func textFieldChange(_ sender: UITextField) {
        
        switch sender {
        case passTF:
            if passTF.text!.count > 5 {
                isValidPass = true
            }else {
                isValidPass = false
            }
        case cPassTF:
            if cPassTF.text == passTF.text {
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
    
    func backDays(loc: [SelectDays]) {
        self.deliveryDaysTF.text! = ""
        self.deliveryDays.removeAll()
        days = loc
        for day in loc {
            if day.isSelected {
                deliveryDays.append(day.name)
            }
        }
        
        self.deliveryDaysTF.text = deliveryDays.joined(separator:",")
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let vc = SelectionDaysVC()
        vc.delegate = self
        vc.checkDaySelect = days
        pushVC(vc)
    }
    func getCustomerTypeCall()  {
        self.startActivityIndicator()
        guard let id = ApiService.instance.user else { return  }
        let param  = [
            "module":"customer_type",
            "from":"app",
            "user_id":id.id
        ] as [String: Any]
        
        AF.request( "\(BASE_URL)process", method: .post, parameters: param).response { response in
            debugPrint(response)
            if let data = response.data{
                print(data.prettyPrintedJSONString ?? "no data")
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonPetitions = try decoder.decode(CustomerType.self, from: data)
                    self.customeType = jsonPetitions.result
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
       

    }
    
    func setUpData()  {
        guard let user = ApiService.instance.user else { return  }
        nameTF.text = user.name
        emailTF.text = user.email
        phoneTF.text = user.contactNos
        
//        profileImg.sd_setImage(with: URL(string: user.profileImage))
        
        if user.profileImage != "" {
        profileImg.sd_setImage(with: URL(string: user.profileImage))
        }
        customerTypeTF.text = user.customerGrpName
        deliveryDaysTF.text = user.deliveryRequired
//
    }
  
    func changePassAPi()  {
        self.startActivityIndicator()
        let parameters = [
            "new_password":passTF.text!,
            "confirm_new_password":confirmPassTF.text!,
            "module":"update_customer_password",
            "current_password":cPassTF.text!,
            "from":"app",
            "customer_id":ApiService.instance.user!.id
        ] as [String : Any]
        
        AF.request( "\(BASE_URL)process", method: .post, parameters: parameters).response { response in
            debugPrint(response)
            if let data = response.data{
                print(data.prettyPrintedJSONString ?? "no data")
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonPetitions = try decoder.decode(UserModel.self, from: data)
                    if jsonPetitions.result == "true" {
                        self.showToast(message: "PassWord Updated")
                    }else {
                        self.showAlert(text: jsonPetitions.errorMsg!)
                    }
                
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
    }
    func imagupload(){
        
        self.startActivityIndicator()
        let imgData = profileImg.image!.jpegData(compressionQuality: 0.2)!
        let parameters = [
            "customer_group":self.customerTypeTF.text!,
            "delivery_required":deliveryDays.joined(separator:", ").description,
            "contact_no":phoneTF.text!,
            "module":"update_customer_profile",
            "customer_email":emailTF.text!,
            "from":"app",
            "customer_name":nameTF.text!,
            "customer_id":ApiService.instance.user!.id
        ] as [String : Any]

          let URL = "\(BASE_URL)process"
        AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imgData, withName: "profile_image", fileName: "profile_image", mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
        }, to: URL).response { response in
            
            if response.response?.statusCode == 200 {
                if let data = response.data{
                    print(data.prettyPrintedJSONString ?? "no data")
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let jsonPetitions = try decoder.decode(UserModel.self, from: data)
                        if jsonPetitions.result == "true" {
                            if let json = jsonPetitions.userDetails {
                            ApiService.instance.saveUserToDefaults(user: json)
                                self.showAlert(text: "Profile Updated")
                            }
                            
                        }else {
                            self.showAlert(text: jsonPetitions.errorMsg!)
                        }
            
                    } catch let err {
                        print(err.localizedDescription)
                    }
                    
                    
                }
            } else {
                self.showAlert(text: "Server Error")
            }
            
            
            self.stopActivityIndicator()
        }
          
      }
    
    func uploadPhoto()  {
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (UIAlertAction) in
            self?.imagePicker.sourceType = .camera
            if let picker = self?.imagePicker{
                picker.allowsEditing = true
                picker.modalPresentationStyle = .fullScreen
                self?.present(picker, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] (UIAlertAction) in
            self?.imagePicker.sourceType = .photoLibrary
            if let picker = self?.imagePicker{
                picker.allowsEditing = true
                picker.modalPresentationStyle = .fullScreen
                self?.present(picker, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addActionSheetForiPad(actionSheet: actionSheet)
        self.present(actionSheet, animated: true, completion: nil)
    }
  
    @IBAction func changeImageBtnTapped(_ sender: Any) {
        uploadPhoto()
    }
    
    @IBAction func changePasswordBtnTapped(_ sender: Any) {
        updatePasswordView.isHidden.toggle()
        updatePassBtn.isHidden.toggle()
        
    }
    
    @IBAction func updatePasswordBtnTapped(_ sender: Any) {
        changePassAPi()
    }
    @IBAction func updateBtnTapped(_ sender: Any) {
        imagupload()
    }
    
}

extension UpdateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let editedImage = info[.editedImage] as? UIImage else {
            print("edited not found!")
            return
        }
        profileImg.image = editedImage
    }
}

extension UpdateProfileVC : UIPickerViewDelegate,UIPickerViewDataSource , UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case customerTypePicker:
            return customeType.count
        default :
            break
            
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case customerTypePicker:
            return customeType[row]
    
        default :
            break
            
        }
        return customeType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case customerTypePicker:
            customerTypeTF.text = customeType[row]
        
            
        default :
            break
            
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == customerTypeTF {
                self.customerTypePicker.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(customerTypePicker, didSelectRow: 0, inComponent: 0)
        
            }
            
            
        }
    
    }
    
}
