//
//  StringExt.swift
//  Katch
//
//  Created by Asfand Hafeez on 04/03/2021.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    func isValidUsername() -> Bool {
        return self.range(of: "\\A\\w{3,18}\\z", options: .regularExpression) != nil
    }
    func isNotEmpty()-> Bool {
        return !self.isEmpty
    }
    var isValidName :Bool {
        let nameRegEx = "^[-a-zA-Z0-9-()]+(\\s+[-a-zA-Z0-9-()]+)*$"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: self)
    }
  
    func snakeCased() -> String? {
        let pattern = "([a-z0-9])([A-Z])"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased()
    }
    
    func isValidNumber() -> Bool {
        let pattern = "^[1-9][0-9]*$"
        let namePred = NSPredicate(format:"SELF MATCHES %@", pattern)
        return namePred.evaluate(with: self)
        
        
    }
    
}

