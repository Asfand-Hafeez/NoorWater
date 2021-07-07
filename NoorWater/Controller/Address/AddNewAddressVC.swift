//
//  AddNewAddressVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 21/04/2021.
//

import UIKit
import GoogleMaps
import Alamofire
class AddNewAddressVC: UIViewController ,CLLocationManagerDelegate{
    var addressTypePicker = UIPickerView()
//
    @IBOutlet weak var mapView: GMSMapView!
        var addressLocationPicker = UIPickerView()
    @IBOutlet weak var houseNoTF: UITextField!
    @IBOutlet weak var buildingNoTF: UITextField!
    @IBOutlet weak var addresTypeTF: UITextField!
    @IBOutlet weak var addressLocTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    var locationManager = CLLocationManager()
    var selectedLocation: ItemLocation?
     var location : Location?
    var addressType = ["Home","Office","Other"]
    var addressLocation = ["Sharjah","Abu Dhabi","Ajman","Dubai","Muscat"]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " Add Address"
        setMyCurrentLocation()
        addresTypeTF.inputView = addressTypePicker
        addressTypePicker.delegate = self
        addressTypePicker.dataSource = self
        addressLocationPicker.delegate = self
        addressLocationPicker.dataSource = self
        addressLocTF.inputView = addressLocationPicker
        addresTypeTF.delegate = self
        addressLocTF.delegate = self
        // Do any additional setup after loading the view.
    }
    func setMyCurrentLocation()  {
        //mark
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.mapView.isMyLocationEnabled = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error" + error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        //               let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 15);
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        locationManager.stopUpdatingLocation()
    }

    @IBAction func addBtnTapped(_ sender: Any) {
    
        callAddressApi()
        
    }
    
    func callAddressApi() {
        guard let address = selectedLocation else {return}
        guard let id = ApiService.instance.user else { return  }
    let param  = [
        "address": address.longName,
        "lng": address.long.description,
        "user_id":id.id,
        "street":buildingNoTF.text!,
        "module":"add_new_address",
        "house_no":houseNoTF.text!,
        "from":"ios",
        "type": addresTypeTF.text!,
        "lat":address.lat.description,
        "city_id": addressLocTF.text!,
        "team_id": "sdsd"
        ] as [String:Any]
        
        AF.request( "\(BASE_URL)process", method: .post, parameters: param).response { response in
            debugPrint(response)
            if let data = response.data{
                print(data.prettyPrintedJSONString ?? "no data")
                                
                do {
                    
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonPetitions = try decoder.decode(UserModel.self, from: data)
                    if jsonPetitions.result == "true" {
                        self.navigationController?.popViewController(animated: true)
                        
                    }else {
                        self.showAlert(text: jsonPetitions.errorMsg!)
                    }
                 
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
    }
    
    
}


extension AddNewAddressVC: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        getPlaceBy(lat: mapView.camera.target.latitude, long: mapView.camera.target.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
        getLocationName(from: location) { (address) in
            self.selectedLocation = ItemLocation(name: name, longName: address ?? "", lat: location.latitude, long: location.longitude, placeId: placeID)
            if address != nil{
                self.addressTF.text = address!
            }
            self.addressTF.text = name
            
        }
    }
    func getPlaceBy(lat: Double, long: Double) {
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(long)&key=\(googleKey)"
        
        AF.request( url, method: .get).response { response in
            debugPrint(response)
            if let data = response.data{
                print(data.prettyPrintedJSONString ?? "no data")
                                
                do {
                    
                    let decoder = JSONDecoder()
                    
                    let jsonPetitions = try decoder.decode(PlaceData.self, from: data)
                 
                    if let result = jsonPetitions.results.first{
                        let longName = result.formatted_address
                        let id = result.place_id
                        var name = ""
                        let lat = result.geometry.location.lat
                        let long = result.geometry.location.lng
                        for address in result.address_components{
                            if address.types.first == "country"{
                                name = address.long_name
                            }
                        }
                        self.addressTF.text = longName
                        self.selectedLocation = ItemLocation(name: name, longName: longName, lat: lat, long: long, placeId: id)
                    }
                    
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
        
        
    }
    
    
    
    func getLocationName(from location: CLLocationCoordinate2D, completion: @escaping CompletionString){
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                guard let pm = placemarks as [CLPlacemark]? else {return}
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    completion(addressString)
                }
        })
        
    }
    
}


extension AddNewAddressVC : UIPickerViewDelegate,UIPickerViewDataSource , UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case addressTypePicker:
            return addressType.count
            
        case addressLocationPicker:
            return addressLocation.count
        default :
            break
            
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case addressTypePicker:
            return addressType[row]
            
        case addressLocationPicker:
            return addressLocation[row]
    
        default :
            break
            
        }
        return addressLocation[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case addressTypePicker:
            addresTypeTF.text = addressType[row]
            
        case addressLocationPicker:
            addressLocTF.text = addressLocation[row]
        
            
        default :
            break
            
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == addresTypeTF {
                self.addressTypePicker.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(addressTypePicker, didSelectRow: 0, inComponent: 0)
        
            }
            
            if textField == addressLocTF {
                self.addressLocationPicker.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(addressLocationPicker, didSelectRow: 0, inComponent: 0)
        
            }
            
            
        }
    
    }
    
}
