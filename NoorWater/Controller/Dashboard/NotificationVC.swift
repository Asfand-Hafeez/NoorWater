//
//  NotificationVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 01/05/2021.
//

import UIKit

import Alamofire
class NotificationVC: UIViewController {
    var notification =  [Notification]()
    var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notification"
        setupTableView(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        getNotificationApiCall()
    }
    
    
    func getNotificationApiCall()  {
        self.startActivityIndicator()
        guard let id = ApiService.instance.user else { return  }
        let param  = [
            "module":"get_notification",
            "notification_type": "for_customer",
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
                    let jsonPetitions = try decoder.decode(NotificatonData.self, from: data)
                    if jsonPetitions.notification.count == 0 {
                        self.tableView.setEmptyMessage("No Notification Available")
                    }else {
                        self.notification = jsonPetitions.notification
                        self.tableView.reloadData()
                    }
                    
                    
                    
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
       

    }




}


extension NotificationVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notification[indexPath.row].notification
        cell.detailTextLabel?.text = notification[indexPath.row].notificationDate
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: - NotificatonData
struct NotificatonData : Codable{
    var result: String
    var notification: [Notification]
}

// MARK: - Notification
struct Notification : Codable{
    var dataId, notification, status, notificationDate: String
}
