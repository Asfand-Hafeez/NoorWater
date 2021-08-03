//
//  OrderReviewVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 01/05/2021.
//

import UIKit
import Alamofire
class OrderReviewVC: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timelbl1: UILabel!
    
    @IBOutlet weak var date1Lbl: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var phone: UILabel!
    var param = [String:Any]()
    var cart = [CartQuantity]()
    var address = ""
    var date = ""
    var time = ""
    var cashType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Place Order"
        // Do any additional setup after loading the view.
        setupData()
    }
    func setupData() {
        addressLbl.text = address
        dateLbl.text = date
        deliveryTimeLbl.text = time
        date1Lbl.text = date
        timelbl1.text = time
        paymentMethod.text = cashType
        totalAmountLbl.text = "AED " + cart.first!.cart.price
        itemNameLbl.text =  cart.first!.cart.name
        nameLbl.text = ApiService.instance.user!.name
        phone.text = ApiService.instance.user!.contactNos
        
        
    }
    

    @IBAction func placeOrderBtnTapped(_ sender: Any) {
   placeOrderApi()
    }
    func placeOrderApi() {
        self.startActivityIndicator()
        let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
        AF.request( "\(BASE_URL)process", method: .post, parameters: param,encoding: JSONEncoding.default,headers: headers ).response { response in
            debugPrint(response)
            if let data = response.data{
                print(data.prettyPrintedJSONString ?? "no data")
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonPetitions = try decoder.decode(UserModel.self, from: data)
                    if jsonPetitions.result == "true" {
                        let alertController = UIAlertController(title: "Congrats", message: "Your Order has been Placed", preferredStyle: .alert)

                        let okAction = UIAlertAction(title: "OK", style: .default) {
                              UIAlertAction in
                            ApiService.instance.cartQuantity.removeAll()
                            self.popBack(5)
                          }
                         
                          alertController.addAction(okAction)
                          
                        self.present(alertController, animated: true, completion: nil)
                        
                        
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
    
}
