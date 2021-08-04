//
//  ProductDetailVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 12/06/2021.
//

import UIKit
import SDWebImage
class ProductDetailVC: UIViewController {
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var cartQuantityLbl: UILabel!
    var product : ResultData?
    var quantiy = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product"
        guard let product = product else {
            return
        }
        productImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        productImg.sd_setImage(with: URL(string: product.image), placeholderImage: nil, options: [.progressiveLoad])
        priceLbl.text = "AED " + product.price
        productName.text = product.name
        quantityLbl.text = product.unit

    }
    @IBAction func plusBtnTapped(_ sender: Any) {
        
            quantiy += 1
        cartQuantityLbl.text = quantiy.description
    }
    
    @IBAction func minusBtnTapped(_ sender: Any) {
        if quantiy >= 1 {
            quantiy -= 1
            
        }else {
            quantiy = 0
        }
        cartQuantityLbl.text = quantiy.description
    }
    
    @IBAction func addTocartBtnTapped(_ sender: Any) {
       
        
        
        if ApiService.instance.user != nil {
            if quantiy == 0 {
                self.showAlertWith(text: "Please add Quantity for Order")
            }else {
                guard let product = product else {
                    return
                }
                ApiService.instance.cartQuantity.append(CartQuantity(cart: product, quantity: quantiy))
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            ApiService.instance.setLoginRootVC()
        }
        
        
//        if ApiService.instance.cartQuantity.count != 0  {
//            for (index, element) in ApiService.instance.cartQuantity.enumerated() {
//                if element.cart.id == product.id {
//                    print("Not")
//                    ApiService.instance.cartQuantity.remove(at: index)
//                    ApiService.instance.cartQuantity.insert(CartQuantity(cart: product, quantity: quantiy), at: index)
//                }else {
//                    ApiService.instance.cartQuantity.append(CartQuantity(cart: product, quantity: quantiy))
//                }
//            }
//        }else {
//            
//        }
        
        
//        for (i,v) in ApiService.instance.cartQuantity.enumerated() {
//            if v.cart.id == product.id {
//                ApiService.instance.cartQuantity.insert(CartQuantity(cart: product, quantity: quantiy), at: i)
//            }else {
//
//            }
//        }
        
        
    }
    @IBAction func buyBtnTapped(_ sender: Any) {
        
        if ApiService.instance.user != nil {
            if quantiy == 0 {
                self.showAlertWith(text: "Please add Quantity for Order")
            }else {
                guard let product = product else {
                    return
                }
                ApiService.instance.cartQuantity.append(CartQuantity(cart: product, quantity: quantiy))
                
                let vc  = ShoppingCartVC.instantiate(type: .main)
                pushVC(vc)
            }
            
        }else{
            ApiService.instance.setLoginRootVC()
        }
        
      
        
        
    }
    

}
