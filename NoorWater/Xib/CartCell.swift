//
//  CartCell.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 01/05/2021.
//

import UIKit
import SDWebImage
class CartCell: UITableViewCell {
    @IBOutlet weak var productImg: UIImageView!
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var resuslt : CartQuantity! {
        didSet {
            productImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            productImg.sd_setImage(with: URL(string: resuslt.cart.image), placeholderImage: nil, options: [.progressiveLoad])
            let priceTotal = (resuslt.cart.price as NSString).integerValue
            
            price.text =  "AED "  + ( priceTotal * resuslt.quantity ).description
            titleLbl.text = resuslt.cart.name
            quantityLbl.text  = "Quantity " + resuslt.quantity.description
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
