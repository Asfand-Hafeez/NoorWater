//
//  ShoppingCartVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 01/05/2021.
//

import UIKit

class ShoppingCartVC: UIViewController {

    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deliveryBtn: UIButton!
    var val = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Shopping Cart"
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for cart in ApiService.instance.cartQuantity {
            let  value = (cart.cart.price as NSString).integerValue
            let v1 = value * cart.quantity
                
                val += v1
            totalPriceLbl.text = "Total AED " +  val.description
        }
       
        
        clearView()
    }
    
    func clearView()  {
        if ApiService.instance.cartQuantity.count == 0 {
//            self.tableView.isHidden  = true
            self.tableView.setEmptyMessage("No Cart Available")
            self.totalPriceLbl.isHidden = true
            deliveryBtn.isHidden = true
        }else {
            self.totalPriceLbl.isHidden = false
            deliveryBtn.isHidden = false
        }
        
    }
    

    @IBAction func deliveryBtnTapped(_ sender: Any) {
        let vc = PlaceOrderVC.instantiate(type: .main) as! PlaceOrderVC
        vc.cart = ApiService.instance.cartQuantity
        pushVC(vc)
    }


}
extension ShoppingCartVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ApiService.instance.cartQuantity.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartCell
        cell.resuslt = ApiService.instance.cartQuantity[indexPath.row]
        cell.crossBtn.addTarget(self, action: #selector(deleteBtn(sender:)), for: .touchUpInside)
        cell.crossBtn.tag = indexPath.row
        return cell
    }
    @objc func deleteBtn(sender: UIButton) {
//        ApiService.instance.cartQuantity[sender.tag]
        let indexPath = IndexPath(row: sender.tag, section: 0)
        ApiService.instance.cartQuantity.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
            
        val = 0
        for cart in ApiService.instance.cartQuantity {
            let  value = (cart.cart.price as NSString).integerValue
            let v1 = value * cart.quantity
                
                val += v1
            totalPriceLbl.text = "Total AED " +  val.description
        }
        clearView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
