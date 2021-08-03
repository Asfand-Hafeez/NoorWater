//
//  ContactUsVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 13/06/2021.
//

import UIKit
import MessageUI
class ContactUsVC: UIViewController , MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   @IBAction func crossBtnTapped()  {
       self.dismissVC()
    }

    @IBAction func whatsAppBtn(_ sender: Any) {
        openWhatsapp(whatsAppUrl: "https://api.whatsapp.com/send?phone=+971551984504")
    }
    
    

func openWhatsapp(whatsAppUrl: String){
    if let urlString = whatsAppUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
        if let whatsappURL = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(whatsappURL){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(whatsappURL)
                }
            }
            else {
                print("Install Whatsapp")
            }
        }
    }
}
    
    @IBAction func emailBtn(_ sender: Any) {
        sendEmail()
    }
    
    @IBAction func callUsBtn(_ sender: Any) {
    dialNumber(number: "+971551984504")
    }
    
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["codingbiz2016@gmail.com"])
            mail.setMessageBody("<p>We want to Contact</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    
}
