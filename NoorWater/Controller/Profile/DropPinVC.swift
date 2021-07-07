//
//  DropPinVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 27/05/2021.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
class DropPinVC: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var headingLbl: UILabel!
    var locationManager = CLLocationManager()
    var selectedLocation: ItemLocation?
     var location : Location?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMyCurrentLocation()
        title = "Drop Pin"
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
    
   @IBAction func addAddressBtnTapped()  {
    if selectedLocation == nil {
        showToast(message: "Please Select Address")
    }else {
        if let loc = selectedLocation {
            self.navigationController?.popViewController(animated: true)
            location?.setLocation(loc: loc)
        }
        
    }
    }
    
    
   @IBAction func currentLocationBtnTapped() {
        setMyCurrentLocation()
    }
    @IBAction func autocompleteClicked(_ sender: UIButton) {
    

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue) |
                                                    UInt(GMSPlaceField.coordinate.rawValue) |
                                                    GMSPlaceField.addressComponents.rawValue |
                                                    UInt(GMSPlaceField.rating.rawValue) |
                                                    GMSPlaceField.formattedAddress.rawValue)
        
        autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        autocompleteController.modalPresentationStyle = .fullScreen
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
}


extension DropPinVC: GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate{
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        getPlaceBy(lat: mapView.camera.target.latitude, long: mapView.camera.target.longitude)
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
                        self.headingLbl.text = longName
                        self.selectedLocation = ItemLocation(name: name, longName: longName, lat: lat, long: long, placeId: id)
                    }
                    
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
        
        
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismissVC()
        mapView.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        headingLbl.text = place.formattedAddress
        selectedLocation = ItemLocation(name: place.name ?? "", longName: place.formattedAddress ?? "", lat: place.coordinate.latitude, long: place.coordinate.longitude, placeId: place.placeID ?? "")

    }
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
        getLocationName(from: location) { (address) in
            self.selectedLocation = ItemLocation(name: name, longName: address ?? "", lat: location.latitude, long: location.longitude, placeId: placeID)
            if address != nil{
                self.headingLbl.text = address!
            }
            self.headingLbl.text = name
            
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        
        return true
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        self.dismissVC()
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

