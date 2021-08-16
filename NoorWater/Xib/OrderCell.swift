//
//  OrderCell.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 05/06/2021.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var orderNameLbl: UILabel!
    @IBOutlet weak var orderTypeImg: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    var result : DeliveredOrdersList! {
        didSet {
            orderNoLbl.text = "Order No. " +  result.orderNum.description
            dateLbl.text = result.orderDateTime
            
//            orderNameLbl.text = result.products.first!.name  + " * " + result.products.first!.qty.description
////            priceLbl.text =  "AED " + (result.products.first!.price * result.products.first!.qty).description
            addressLbl.text = result.address
            
            if result.orderStatus == "pending" {
                cancelBtn.setTitle("Cancel", for: .normal)
                
            } else if result.orderStatus == "deliver" {
                cancelBtn.setTitle("Reorder", for: .normal)
            } else if result.orderStatus == "cancel" {
                cancelBtn.setTitle("Restore", for: .normal)
            }
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
