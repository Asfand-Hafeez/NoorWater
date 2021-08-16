//
//  ApiService.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 15/04/2021.
//

import Foundation
import UIKit
import KYDrawerController
class ApiService {
    static let instance = ApiService()
    var user : UserDetails?
    var cartQuantity = [CartQuantity]()
    let defaults = UserDefaults.standard
    let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
    var pushDelegate : PushViewDelegate?
    func setDashBoardRootVC() {
        
        if let window = UIApplication.shared.windows.first{
            window.makeKeyAndVisible()
            let mainViewController   = UINavigationController(rootViewController: DashboardVC.instantiate(type: .main))
            
            
            
            let drawerViewController = UINavigationController(rootViewController: LeftMenuVC.instantiate(type: .main))
            
                  drawerController.mainViewController =  mainViewController
                  
                  drawerController.drawerViewController = drawerViewController
        
                 
            window.rootViewController = drawerController
        }
    }
    func saveUserToDefaults(user: UserDetails) {
        self.user = user
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: "user")
        }
    }
 
    func updateUserInApiService(){
        if let safeUser = defaults.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let savedUser = try? decoder.decode(UserDetails.self, from: safeUser) {
                user = savedUser
            }else{
                print("error in updating user")
            }
        }
    }
    func getHeader()-> [String: String] {
        return [
            "Content-Type":"application/json",
            "Accept" : "application/json",
            "Host": "<calculated when request is sent>",
            "Content-Length":"<calculated when request is sent>"
//            "Content-Type": "multipart/form-data; boundary=<calculated when request is sent>"
        ]
    }
    func resetDefaults() {
        let dictionary = defaults.dictionaryRepresentation()
        
        dictionary.keys.forEach { key in
            if key == "isSplashSeen" {
               return
            }
            defaults.removeObject(forKey: key)
        }
    }
    
    func setLoginRootVC() {
        if let window = UIApplication.shared.windows.first{
            window.rootViewController = UINavigationController(rootViewController: LoginVC.instantiate(type: .Profile))
            window.makeKeyAndVisible()
        }
    }
    
    func isSplashSeen(value : Bool)  {
        defaults.setValue(value, forKey: "isSplashSeen")
    }
    
    func getIsSplashSeen() -> Bool  {
        return defaults.bool(forKey: "isSplashSeen")
    }
    
    
}
