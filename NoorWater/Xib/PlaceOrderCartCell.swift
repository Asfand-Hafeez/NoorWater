//
//  PlaceOrderCartCell.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 05/06/2021.
//

import UIKit
import SDWebImage
class PlaceOrderCartCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var priceeLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var resuslt : CartQuantity! {
        didSet {
            productImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            productImg.sd_setImage(with: URL(string: resuslt.cart.image), placeholderImage: nil, options: [.progressiveLoad])
            let priceTotal = (resuslt.cart.price as NSString).integerValue
            
            priceeLbl.text =  ( priceTotal * resuslt.quantity ).description
            itemNameLbl.text = resuslt.cart.name
            quantityLbl.text  = "X     " + resuslt.quantity.description
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
