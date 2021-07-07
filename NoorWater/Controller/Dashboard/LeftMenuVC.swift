//
//  LeftMenuVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 15/04/2021.
//

import UIKit

class LeftMenuVC: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var profileImg : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    
    var sideMenu = [SideMenu]()
    var delegate : PushViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        sideMenu = [
            SideMenu(name: "Home", icon: #imageLiteral(resourceName: "home (2)")),
            SideMenu(name: "Orders", icon: #imageLiteral(resourceName: "shopping-bag")),
            SideMenu(name: "My Wallet", icon: #imageLiteral(resourceName: "walleticon")),
            SideMenu(name: "Address", icon: #imageLiteral(resourceName: "location")),
            SideMenu(name: "Profile", icon: #imageLiteral(resourceName: "user (1)")),
            SideMenu(name: "Notification", icon: #imageLiteral(resourceName: "bell")),
            SideMenu(name: "Feedback", icon: #imageLiteral(resourceName: "files")),
            SideMenu(name: "Rate Us", icon: UIImage(named: "Rate-Us")!),
            SideMenu(name: "Tell a friend", icon: #imageLiteral(resourceName: "files")),
            SideMenu(name: "Contact Us", icon: #imageLiteral(resourceName: "files")),
            SideMenu(name: "Logout", icon: #imageLiteral(resourceName: "ic_next_product")),
        ]
        setupData()
    }
    

    func setupData () {
        guard let user = ApiService.instance.user else { return  }
        nameLbl.text = user.name
        profileImg.sd_setImage(with: URL(string: user.profileImage))
        
    }
  

}

extension LeftMenuVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SideMenuCell
        cell.icon.image = sideMenu[indexPath.row].icon
        cell.titleName.text = sideMenu[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.navigationBar.isHidden = false
        
//        switch indexPath.row {
//        case 0 :
//            ApiService.instance.setDashBoardRootVC()
//
//        case 1 :
//            let vc = UINavigationController(rootViewController: OrderVC())
//            ApiService.instance.drawerController.mainViewController = vc
//
//        case 2 :
//            let vc = UINavigationController(rootViewController: WalletVC.instantiate(type: .main))
//            ApiService.instance.drawerController.mainViewController = vc
//        case 4:
//            let vc = UINavigationController(rootViewController: UpdateProfileVC.instantiate(type: .main))
//            ApiService.instance.drawerController.mainViewController = vc
//
//        case 3:
//            let vc = UINavigationController(rootViewController: SavedAddress.instantiate(type: .main))
//            ApiService.instance.drawerController.mainViewController = vc
//
//        case 6:
//            let vc = UINavigationController(rootViewController: FeedbackVC.instantiate(type: .main))
//            ApiService.instance.drawerController.mainViewController = vc
//
//        case 10:
//
//            ApiService.instance.resetDefaults()
//            ApiService.instance.setLoginRootVC()
//
//        default:
//            break
//        }
        ApiService.instance.pushDelegate?.pushVCFromSideMenu(int: indexPath.row)
        ApiService.instance.drawerController.setDrawerState(.closed, animated: true)
        
    }
}

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var titleName : UILabel!
    @IBOutlet weak var icon : UIImageView!
}


struct SideMenu {
    let name : String
    let icon : UIImage
}



protocol PushViewDelegate {
    func pushVCFromSideMenu(int:Int)
}


