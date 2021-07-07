//
//  OrderVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 01/05/2021.
//

import UIKit
import Alamofire
import KYDrawerController
class OrderVC: UIViewController {
    var segmentControl = UISegmentedControl()
    let tableView = UITableView()
    var ordertData = [DeliveredOrdersList]()
    var tabOrder = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        let segmentItems = ["All", "Pending","Delivered", "Cancelled"]
          segmentControl = UISegmentedControl(items: segmentItems)
        
        segmentControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
          view.addSubview(segmentControl)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -10),
            segmentControl.heightAnchor.constraint(equalToConstant: 40),
            segmentControl.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "cell")
        title = "My Orders"
        // Do any additional setup after loading the view.
//        setUpNavbar()
        getOrderApiCall(index: 0)
    }
//    func setUpNavbar() {
//        let menuTapGesture = UITapGestureRecognizer()
//        let menuView = UIView(frame: CGRect(x: 0, y:0, width: 60, height:60))
//        let image = UIImage(named: "burger")
//        let imageView = UIImageView(image: image!)
//        imageView.contentMode = .scaleAspectFill
//            imageView.frame = CGRect(x: -15, y: 0, width: 60, height: 50)
//        menuView.layer.zPosition = 999
//        menuView.addSubview(imageView)
//        let barButtonItem = UIBarButtonItem(customView: menuView)
//        barButtonItem.action = #selector(menuBtnTapped)
//        navigationItem.leftBarButtonItem = barButtonItem
//        menuView.addGestureRecognizer(menuTapGesture)
//        menuTapGesture.addTarget(self, action: #selector(menuBtnTapped))
//
//
//    }
//    @IBAction func menuBtnTapped()  {
//     if let drawerController = navigationController?.parent as? KYDrawerController {
//                drawerController.setDrawerState(.opened, animated: true)
//            }
//     }
    
   
    
    func cancelOrderApiCall(index: Int)  {
        self.startActivityIndicator()
        guard let id = ApiService.instance.user else { return  }
        let param  = [
            "module":"status_update_by_customer",
            "from":"app",
            "order_id":self.ordertData[index].orderNum,
            "customer_id":ApiService.instance.user!.id,
            "status":3
            
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
                        self.getOrderApiCall(index: self.tabOrder)
                        
                    }else {
                        self.showAlert(text: "Something went wrong")
                    }
                    
                    
                    
                    
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
       

    }
    
    func getOrderApiCall(index: Int)  {
        ordertData.removeAll()
        self.startActivityIndicator()
        guard let id = ApiService.instance.user else { return  }
        let param  = [
            "module":"get_customer_orders",
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
                    let jsonPetitions = try decoder.decode(GetOrder.self, from: data)
                    switch index {
                    case 0:
                        
                        if jsonPetitions.allOrders.count == 0 {
                            self.tableView.setEmptyMessage("No Order Availabe")
                        }else {
                            self.ordertData = jsonPetitions.allOrders
                        }
                    case 1:
                        

                        if jsonPetitions.inProcessOrdersList.count == 0 {
                            self.tableView.setEmptyMessage("No Order Availabe")
                        }else {
                            self.ordertData = jsonPetitions.inProcessOrdersList
                        }
                    case 2:
                       if jsonPetitions.deliveredOrdersList.count == 0 {
                            self.tableView.setEmptyMessage("No Order Availabe")
                        }else {
                        
                            self.ordertData = jsonPetitions.deliveredOrdersList
                        }
                        
                    case 3:
                        
                        if jsonPetitions.cancelledOrdersList.count == 0 {
                            self.tableView.setEmptyMessage("No Order Availabe")
                        }else {
                        
                            self.ordertData = jsonPetitions.cancelledOrdersList
                        }
                    default:
                        break
                    }
                    self.tableView.reloadData()
                    
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
       

    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0:
             print("First")
           getOrderApiCall(index: 0)
            tabOrder = 0
          case 1:
           getOrderApiCall(index: 1)
            tabOrder = 1
       case 2:
           getOrderApiCall(index: 2)
        tabOrder = 2
       case 3:
           getOrderApiCall(index: 3)
        tabOrder = 3
          default:
          break
       }
    }

}



extension OrderVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordertData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderCell
        cell.result = ordertData[indexPath.row]
        cell.viewBtn.tag = indexPath.row
        cell.viewBtn.addTarget(self, action: #selector(ViewBtnTapped(sender:)), for: .touchUpInside)
        
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(CancelBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func ViewBtnTapped(sender: UIButton) {
        let vc = OrderDetailVC.instantiate(type: .main) as! OrderDetailVC
        vc.orderDetail = ordertData[sender.tag]
        pushVC(vc)
        
        
        
    }
    
    @objc func CancelBtnTapped(sender: UIButton) {
        
        
        cancelOrderApiCall(index: sender.tag)
        
    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    
}
