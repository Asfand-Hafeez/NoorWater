//
//  LaunchVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 25/04/2021.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let window = UIApplication.shared.windows.first{
                window.rootViewController =  OnBoardingVC.instantiate(type: .Profile)
                window.makeKeyAndVisible()
            }
            
        }
        
    }
    


}
