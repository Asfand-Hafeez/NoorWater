//
//  UIViewControllerExt.swift
//  Katch
//
//  Created by Asfand Hafeez on 03/03/2021.
//

import Foundation
import UIKit
extension UIViewController{
    func setupNavBar(foregroundColor: UIColor, textColor: UIColor) {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: textColor]
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.barTintColor = .systemBackground
        } else {
            navigationController?.navigationBar.barTintColor = .white
        }
        navigationController?.navigationBar.tintColor = textColor
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.largeTitleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: textColor,
//            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 20)!
//            
//        ]
    }
    func transparentNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    func restoreNavBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    func finishAlert()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
    
    var activityIndicatorTag: Int { return 999999 }
    func startActivityIndicator(
        style: UIActivityIndicatorView.Style = .gray,
        location: CGPoint? = nil) {
        
        //Set the position - defaults to `center` if no`location`
        
        //argument is provided
        
        let loc = location ?? self.view.center
        
        //Ensure the UI is updated from the main thread
        
        //in case this method is called from a closure
        
        DispatchQueue.main.async {
            
            //Create the activity indicator
            
            let activityIndicator = UIActivityIndicatorView(style: style)
            //Add the tag so we can find the view in order to remove it later
            
            activityIndicator.tag = self.activityIndicatorTag
            //Set the location
            if #available(iOS 13.0, *) {
                activityIndicator.color = .label
            } else {
                activityIndicator.color = .black
            }
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            //Start animating and add the view
            
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }
    
    func stopActivityIndicator() {
        
        //Again, we need to ensure the UI is updated from the main thread!
        
        DispatchQueue.main.async {
            
            
            //Here we find the `UIActivityIndicatorView` and remove it from the view
            
            if let activityIndicator = self.view.subviews.filter(
                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
    
    func showKatchLoadingAlert() {
        //           guard let lang = ApiService.instance.langugaeString?.general_validation else {return}
//        guard Reachability.isConnectedToNetwork() else {
//            //               guard let lang = ApiService.instance.langugaeString?.general_errors else {return}
//            //               showTravelistAlert(text: lang.internet_offline_message)
//            showAlertWith(text: "Your device in not connected to internet")
//            return
//        }
        //           showLoadingAlert(text: lang.please_wait)
        //        showLoadingAlert(text: "Please wait")
    }
    func showAlertWith(text: String) {
        //        guard let lang = ApiService.instance.langugaeString?.general_validation else {return}
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        //        lang.general_ok
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            default:
                break
            }}))
        self.present(alert, animated: true, completion: nil)
    }
//    func showAlertAction(title: String, message: String, destructiveTitle: String,cancel:String ,completion: @escaping CompletionHandler){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: cancel, style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: destructiveTitle, style: .destructive, handler: {(action:UIAlertAction!) in
//            completion(true)
//        }))
//
//        self.present(alert, animated: true, completion: nil)
//    }
    func loadingIndicator(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .medium
        } else {
            loadingIndicator.style = .gray
        }
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    public func addActionSheetForiPad(actionSheet: UIAlertController) {
        if let popoverPresentationController = actionSheet.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
    
    func backTwoViewController() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
//    func setUpNavigationAlignment() {
//        if ApiService.instance.getIsRtl() == 1{
//            navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
//            navigationController?.navigationBar.subviews[1].semanticContentAttribute = .forceRightToLeft
//            navigationController?.view.semanticContentAttribute = .forceRightToLeft
//        }else {
//            navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
//            navigationController?.view.semanticContentAttribute = .forceLeftToRight
//            navigationController?.navigationBar.subviews[1].semanticContentAttribute = .forceLeftToRight
//        }
//    }
    func setupCustomBackButtonImage() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    func makeNavigationBarTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    func restoreNavbar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
//    func setupSearchResultRtl()  {
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "passenger_cancel_button".localize()
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = themePurple
//        if ApiService.instance.getIsRtl() == 1 {
//            UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
//            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textAlignment = .right
//        }else{
//            UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
//            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textAlignment = .left
//        }
//    }
//    func setNavigationAllignment() {
//        if ApiService.instance.getIsRtl() == 1{
//            navigationController?.view.semanticContentAttribute = .forceRightToLeft
//            navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
//
//        }else{
//            navigationController?.view.semanticContentAttribute = .forceLeftToRight
//            navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
//
//        }
//    }
   
    static func instantiate(type: boardType) -> UIViewController{
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: type.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id)
        
    }
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    static func instantiateProfile() -> UIViewController{
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id)
        
    }
        func showAlertAction(title: String, message: String, destructiveTitle: String,cancel:String ,completion: @escaping CompletionHandler){
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: cancel, style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: destructiveTitle, style: .destructive, handler: {(action:UIAlertAction!) in
                completion(true)
            }))
    
            self.present(alert, animated: true, completion: nil)
        }
        func showOKAlertAction(title: String,actionMessage: String, completion: @escaping CompletionHandler){
            let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: actionMessage, style: .default, handler: {(action:UIAlertAction!) in
                completion(true)
            }))
    
            self.present(alert, animated: true, completion: nil)
        }
    func showToast(message : String) {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func setupTableView(_ tableView: UITableView) {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        tableView.tableFooterView = UIView()
    }
    func setUpShareSheet(shareListId:Int16)  {
        let text = "https://nodejsblog.000webhostapp.com/list/\(shareListId)"
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

enum boardType: String{
    case main = "Main"
    case Profile = "Profile"
}
public extension Collection {

    /// Convert self to JSON String.
    /// Returns: the pretty printed JSON string or an empty string if any error occur.
    func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            print("json serialization error: \(error)")
            return "{}"
        }
    }
}

extension UITableView {
    func setEmptyMessageTV(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        
//        messageLabel.textColor = .appColor(.themeLightGray)
        
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
}



