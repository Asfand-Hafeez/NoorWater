//
//  SelectionDaysVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 30/05/2021.
//

import UIKit

class SelectionDaysVC: UIViewController {
var tableView = UITableView()
//    var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var selectedDays = [String]()
    var days = [SelectDays]()
    var checkDaySelect = [SelectDays]()
    var delegate : GetBackDeliveryDays?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Delivey Days"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupTableView(tableView)
        setUpData()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(buttonTapped(sender:)))
        navigationItem.rightBarButtonItems = [ done]
    }
    func setUpData()  {
    days = [
    SelectDays(name: "Monday", isSelected: false),
        SelectDays(name: "Tuesday", isSelected: false),
        SelectDays(name: "Wednesday", isSelected: false),
        SelectDays(name: "Thursday", isSelected: false),
        SelectDays(name: "Friday", isSelected: false),
        SelectDays(name: "Saturday", isSelected: false),
        SelectDays(name: "Sunday", isSelected: false)
    ]
//        for day in checkDaySelect {
//            for var  day1 in days {
//                if day.isSelected == day1.isSelected {
//                    day1.isSelected = true
//                }
//            }
//        }
//
//     let day1 =   days.elementsEqual(checkDaySelect, by: { $0.isSelected == $1.isSelected
//
//        })
//        print(day1)
//
        
    }
    
  
 

}
extension SelectionDaysVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = days[indexPath.row].name
        if days[indexPath.row].isSelected == true {
                    cell.accessoryType = .checkmark
        }else {
                    cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedDays.removeAll()
        if days[indexPath.row].isSelected == true {
            days[indexPath.row].isSelected = false
        }else {
            days[indexPath.row].isSelected = true
            
            
        }
        
        tableView.reloadData()
    }

    
   @objc func buttonTapped(sender: UIButton) {
    
    self.delegate?.backDays(loc: days)
    self.navigationController?.popViewController(animated: true)
    

    }
    
    
    
}

struct SelectDays {
    var name : String
    var isSelected : Bool
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
