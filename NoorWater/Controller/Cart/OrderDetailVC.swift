//
//  OrderDetailVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 01/05/2021.
//

import UIKit

class OrderDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    

    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var cashType: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var orderBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var balanceDue: UILabel!
    @IBOutlet weak var paid: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var orderDetail:DeliveredOrdersList?
    var totalPric = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let order = orderDetail else { return  }
        
        
        
        if order.status == "Deliverd" {
            orderBtn.isHidden = false
            orderBtn.setTitle("Re order", for: .normal)
        }else if order.status == "Cancel" {
            orderBtn.isHidden = false
            orderBtn.setTitle("Restore", for: .normal)
        }else {
            orderBtn.isHidden = true
        }
        orderNoLbl.text = "Order No. \(order.orderNum)"
        dateLbl.text = order.orderDateTime
        orderStatus.text = order.status
        address.text = order.address
        cashType.text = order.paymentMethod
        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeight.constant = CGFloat(order.products.count * 50)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        paid.text = order.paid.description
        discountLbl.text = order.dsicount.description
        
        for product in order.products {
            totalPric += product.price
        }
        
//        HELLO
        // ASFAND
        
        
        
        
        
        
        totalPrice.text = "AED " + totalPric.description
        total.text = "AED " + totalPric.description
        balanceDue.text =  "AED " + totalPric.description
    }
    

    @IBAction func ReOrderBtnTapped(_ sender: Any) {
        guard let product = orderDetail else {
            return
        }
        for (i,v) in product.products.enumerated() {
            ApiService.instance.cartQuantity.append(CartQuantity(cart: ResultData(id: i.description, productId: v.id.description, name: v.name, price: v.price.description, unit: "0", image: v.image), quantity: v.qty))
        }
        
        
//
        let vc  = ShoppingCartVC.instantiate(type: .main)
        pushVC(vc)
    }
    
    
    @IBAction func chatBtnTapped(_ sender: Any) {
        self.openWhatsapp(whatsAppUrl: "https://api.whatsapp.com/send?phone=+971551984504")
    }
    func openWhatsapp(whatsAppUrl: String){
        if let urlString = whatsAppUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetail?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderDetailCell
        cell.selectionStyle = .none
        cell.order = orderDetail?.products[indexPath.row]
        return cell
    }
    
    
}


class OrderDetailCell: UITableViewCell {
    @IBOutlet weak var orderLbl: UILabel!
    
    @IBOutlet weak var quantityLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    var order : Product! {
        didSet {
            orderLbl.text = order.name
            quantityLbl.text = order.qty.description
            priceLbl.text = "AED " + order.price.description
        }
    }
    
}
