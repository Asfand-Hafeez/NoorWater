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
        
//        sdsd
        totalPrice.text = "AED " + totalPric.description
        total.text = "AED " + totalPric.description
        balanceDue.text =  "AED " + totalPric.description
    }
    

    @IBAction func ReOrderBtnTapped(_ sender: Any) {
        guard let product = orderDetail else {
            return
        }
//        let cart =  product.products.first
//        ApiService.instance.cartQuantity.append(CartQuantity(cart: ResultData(id: cart!.id, productId: <#T##String#>, name: <#T##String#>, price: <#T##String#>, unit: <#T##String#>, image: <#T##String#>), quantity: product.products.first!.qty))
        
        let vc  = ShoppingCartVC.instantiate(type: .main)
        pushVC(vc)
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
