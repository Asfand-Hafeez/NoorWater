//
//  PlaceOrderVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 26/06/2021.
//

import  UIKit
import  Alamofire
class PlaceOrderVC: UIViewController , UITextViewDelegate , Location{
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var cashBtn: [UIButton]!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var addressTF: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var placeOrderBtn: UIButton!
    
    var val = 0
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var isSelectCash = ""
    
    var cart = [CartQuantity]()
    var selectedLoc : ItemLocation?
    var isValidDate = false
    var isValidTime = false
    var isValidAddress = false
    @IBOutlet weak var height: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Place Order"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlaceOrderCartCell", bundle: nil), forCellReuseIdentifier: "cell")
        setupPicker()
        for cart in cart {
            let  value = (cart.cart.price as NSString).integerValue
            let v1 = value * cart.quantity
                
                val += v1
            totalPriceLbl.text = "AED " +  val.description
        }
        height.constant = CGFloat(cart.count * 100) + 50.0
        
        if let userAddress = ApiService.instance.user?.customerAddress {
            selectedLoc = ItemLocation(name: userAddress.address, longName: userAddress.address, lat: userAddress.lat.toDouble(), long: userAddress.lng.toDouble(), placeId: userAddress.addressId)
            isValidAddress = true
            self.addressTF.text = userAddress.address + userAddress.houseNo
        }
    }
    
    
    func setupPicker()  {
        dateTF.delegate = self
        timeTF.delegate = self
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        timePicker.datePickerMode = .time
        timePicker.minimumDate = Date()
//        timePicker.minuteInterval = 10
        
        dateTF.inputView = datePicker
        timeTF.inputView = timePicker

    }

    
    @IBAction func cashMethodTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            cashBtn[0].setImage(#imageLiteral(resourceName: "dot"), for: .normal)
            cashBtn[1].setImage(#imageLiteral(resourceName: "circle1"), for: .normal)
            cashBtn[2].setImage(#imageLiteral(resourceName: "circle1"), for: .normal)
            cashBtn[3].setImage(#imageLiteral(resourceName: "circle1"), for: .normal)
            isSelectCash = "Cash on Delivery"
            
            
        case 1:
//            cashBtn[1].setImage(#imageLiteral(resourceName: "button"), for: .normal)
//            cashBtn[0].setImage(#imageLiteral(resourceName: "circle"), for: .normal)
//            cashBtn[2].setImage(#imageLiteral(resourceName: "circle"), for: .normal)
//            cashBtn[3].setImage(#imageLiteral(resourceName: "circle"), for: .normal)
//
//            isSelectCash = 0
//            isSelectWallet = 0
//            isSelectCredit = 0
//            isSelectCard = 1
            self.showToast(message: "This Method not available")
        case 2:
            
            
            
            cashBtn[2].setImage(#imageLiteral(resourceName: "dot"), for: .normal)
            cashBtn[1].setImage(#imageLiteral(resourceName: "circle1"), for: .normal)
            cashBtn[0].setImage(#imageLiteral(resourceName: "circle1"), for: .normal)
            cashBtn[3].setImage(#imageLiteral(resourceName: "circle1"), for: .normal)
            
            isSelectCash = "Wallet"
            
        case 3:
//            cashBtn[3].setImage(#imageLiteral(resourceName: "button"), for: .normal)
//            cashBtn[0].setImage(#imageLiteral(resourceName: "circle"), for: .normal)
//            cashBtn[1].setImage(#imageLiteral(resourceName: "circle"), for: .normal)
//            cashBtn[2].setImage(#imageLiteral(resourceName: "circle"), for: .normal)
//
            self.showToast(message: "This Method not available")
           
        default:
            break
        }
        
        
        
    }
    func validation()  {
        if isValidDate && isValidTime && isValidAddress {
            placeOrderBtn.isUserInteractionEnabled = true
        }else {
            placeOrderBtn.isUserInteractionEnabled = false
        }
    }
    @IBAction func placeOrderBtnTapped(_ sender: Any) {
        
        var selectedCart = [[String: Any]]()
        func map() -> [[String: Any]]{
            for value in cart {
                let json = (["ProductID": value.cart.id, "Product_Name": value.cart.name, "ProductQuantity": value.quantity ,"TotalAmount":value.cart.price] as [String : Any])
                selectedCart.append(json )
            }
            return selectedCart
        }
        
        guard let loc = selectedLoc else {return}
        let param = [
            "note":"",
            "delivery_date": dateTF.text!,
            "address":loc.placeId,
            "user_id":ApiService.instance.user!.id,
            "module":"place_order",
            "from":"ios",
            "delivery_time":timeTF.text!,
            "cart":map(),
            "payment_method":isSelectCash
        ] as [String: Any]
        
      print(param)
        let vc = OrderReviewVC.instantiate(type: .main) as! OrderReviewVC
        vc.param = param
        vc.cart = cart
        vc.address = selectedLoc!.name + selectedLoc!.longName
        vc.date = dateTF.text!
        vc.time = timeTF.text!
        vc.cashType = isSelectCash
        pushVC(vc)
        

        
        
    }
            
        
        

        
    
    
    
    
    @IBAction func changeAddressBtnTapped(_ sender: Any) {
        let vc = SavedAddress.instantiate(type: .main) as! SavedAddress
        vc.isComingFromPlace  = true
        vc.location = self
        pushVC(vc)
        
    }
    func setLocation(loc: ItemLocation) {
        selectedLoc = loc
        addressLbl.text = loc.name + loc.longName
        isValidAddress = true
        validation()
        
    }
    
    
}
extension PlaceOrderVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceOrderCartCell
        cell.resuslt = cart[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

extension PlaceOrderVC : UITextFieldDelegate  {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        switch textField {
        case dateTF:
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            dateTF.text = formatter.string(from: datePicker.date)
            isValidDate = true
        case timeTF:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm"
//            dateFormatter.dateFormat = "HH:mm"
            timeTF.text = dateFormatter.string(from: timePicker.date)
            isValidTime = true
        default:
            break
        }
        validation()
    }
    
}


extension String {
    func toDouble() -> Double  {
        return Double(self) ?? 0.0
    }
}
