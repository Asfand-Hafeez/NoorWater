//
//  SavedAddress.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 21/04/2021.
//

import UIKit
import KYDrawerController
import Alamofire
class SavedAddress: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var address = [AddressData]()
    var location : Location?
    var isComingFromPlace = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Address"
        transparentNavBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.tableHeaderView = UIView()
//        setUpNavbar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAddressApiCall()
    }
    
    func getAddressApiCall()  {
        
        self.startActivityIndicator()
        guard let id = ApiService.instance.user else { return  }
        let param  = [
            "module":"get_customer_addresses",
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
                    let jsonPetitions = try decoder.decode(GetAddress.self, from: data)
                    
                    
                    if jsonPetitions.result.count == 0 {
                        self.tableView.setEmptyMessage("No Address Available")
                    }else {
                        self.address = jsonPetitions.result
                    }
                    self.tableView.reloadData()
                    
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
       

    }

    
    
    func deleteAddressApiCall(tag: Int)  {
        
        self.startActivityIndicator()
        guard let id = ApiService.instance.user else { return  }
        let param  = [
            "module":"remove_customer_address",
            "address_id":self.address[tag].addressId,
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
                    let jsonPetitions = try decoder.decode(UserModel.self, from: data)
                    if jsonPetitions.result == "true" {
                        if let address = jsonPetitions.CurrAddresses {
                            self.address = address
                            self.tableView.reloadData()
                        }
                        
                    }else {
                        self.showToast(message: "Server Error")
                    }
                    
                    
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
       

    }

    
    @IBAction func addNewAddressBtnTapped(_ sender: Any) {
        let vc = AddNewAddressVC.instantiate(type: .main)
        pushVC(vc)
    }
    
 
}


extension SavedAddress : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedAddressCell
        cell.result = address[indexPath.row]
        cell.moreBtn.addTarget(self, action: #selector(deleteBtn(sender:)), for: .touchUpInside)
        cell.moreBtn.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isComingFromPlace {
            let data = address[indexPath.row]
            location?.setLocation(loc: ItemLocation(name: data.address, longName: data.houseNo, lat: Double(data.lat)!, long: Double(data.lat)!, placeId: data.addressId))
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    

@objc func deleteBtn(sender: UIButton) {
    deleteAddSheet(tag: sender.tag)
}
    
    func deleteAddSheet(tag : Int)  {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete Address", style: .default, handler: { [weak self] (UIAlertAction) in
            self?.deleteAddressApiCall(tag: tag)
        }))
        
      
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addActionSheetForiPad(actionSheet: actionSheet)
        self.present(actionSheet, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


class SavedAddressCell: UITableViewCell {
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    var result: AddressData! {
        didSet {
            typeLbl.text = result.type
            addressName.text = result.address
        }
    }
}
