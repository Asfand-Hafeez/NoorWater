//
//  FeedbackVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 01/05/2021.
//

import UIKit
import KYDrawerController
import Alamofire
class FeedbackVC: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var reviewTV: UITextView!
    var imagePicker = UIImagePickerController()
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "FeedBack"
        
    }
    
  
    @IBAction func addImageBtnTapped(_ sender: Any) {
        uploadPhoto()
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        imagupload()
    }
    
    func imagupload(){
        self.startActivityIndicator()
        let imgData = image.jpegData(compressionQuality: 0.2)!
        let parameters = [
            "msg":reviewTV.text!,
            "user_id":ApiService.instance.user!.id,
            "subject":"sdsd",
            "module":"feed_back",
            "from":"app",
            "type":"sddsd"
        ] as [String : Any]

          let URL = "\(BASE_URL)process"
        AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imgData, withName: "attachment", fileName: "attachment", mimeType: "image/png")
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
                            self.navigationController?.popViewController(animated: true)
                            
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
  
    

}


extension FeedbackVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let editedImage = info[.editedImage] as? UIImage else {
            print("edited not found!")
            return
        }
        self.image = editedImage
//        profileImg.image = editedImage
    }
}
