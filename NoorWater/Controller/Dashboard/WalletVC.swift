//
//  WalletVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 01/05/2021.
//

import UIKit
import Alamofire
import KYDrawerController
class WalletVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalWalletLbl: UILabel!
    var walletData = [Datum]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        getWalletApiCall()
//        setUpNavbar()
    }

    
    func getWalletApiCall()  {
        
        self.startActivityIndicator()
        guard let id = ApiService.instance.user else { return  }
        let param  = [
            "module":"get_wallet",
            "from":"app",
            "user_id":id.id
        ] as [String: Any]
        
        AF.request( "\(BASE_URL)process", method: .post, parameters: param).response { response in
            debugPrint(response)
            if let data = response.data{
                print(data.prettyPrintedJSONString ?? "no data")
                                
                do {
                    
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonPetitions = try decoder.decode(GetWallet.self, from: data)
                    
                    
                    
                    
                    if jsonPetitions.data.count == 0 {
                        self.tableView.setEmptyMessage("No Wallet Available")
                    }else {
                        self.walletData = jsonPetitions.data
                        self.totalWalletLbl.text = jsonPetitions.total
                    }
                    self.tableView.reloadData()
                    
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
       

    }
 

}

extension WalletVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WalletCell
        cell.result = walletData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
class WalletCell: UITableViewCell {
    @IBOutlet weak var iconImg: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    var result : Datum! {
        didSet {
            titleLbl.text = result.description
            quantityLbl.text = result.day
            priceLbl.text = "AED " + result.amount
            if result.type == "C" {
                iconImg.image = #imageLiteral(resourceName: "wallet1")
            }else {
                iconImg.image = #imageLiteral(resourceName: "wallet2")
            }
        }
    
    }
    
}
