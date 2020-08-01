//
//  Maps.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 09/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//
import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class Maps:UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate  {
    
    
    @IBOutlet weak var GoogleMapController: UIView!
    var address:String?
    var googlemapsView: GMSMapView!
    var resultArray = [String]()
    let autocompleteController = GMSAutocompleteViewController()
    var delegate:DiaryWriteViewController!
    @IBAction func searchBtn(_ sender: UIButton) {
        
        autocompleteController.delegate = self
        NSLog("2")
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        NSLog("3")
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        NSLog("4")
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        NSLog("5")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let location = locationMgr.location!.coordinate
        let cameraCenter = GMSCameraPosition.camera(withLatitude:
            location.latitude, longitude:
            location.longitude, zoom: 16.0)
        self.googlemapsView = GMSMapView(frame: self.GoogleMapController.frame, camera: cameraCenter)
        
        googlemapsView.isMyLocationEnabled = true
        googlemapsView.settings.myLocationButton = true
        locationMgr.location?.coordinate //현재위치
        
        //  marker.position = CLLocationCoordinate2D(latitude: 37.6281126, longitude: 127.0904568)
        
        //self.GoogleMapsView = GMSMapView(frame: self.GoogleMapController.frame)
        //mapView.isMyLocationEnabled = true
        //mapView.settings.myLocationButton = true
        self.view.addSubview(self.googlemapsView)
        
        
        //let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        //mapView.settings.myLocationButton = true
        
        let mapView = GMSMapView.map(withFrame: self.GoogleMapController.frame, camera: cameraCenter)
        
        //마커찍기
        let position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let marker2 = GMSMarker(position: position)
        marker2.title = "서울여자대학교"
        //marker.iconView = markerView
        marker2.tracksViewChanges = true
        marker2.map = googlemapsView
        //london = marker
        
        // self.GoogleMapController.insertSubview(mapView, at: 0)
        mapView.delegate = self
        
        
        
        //let marker = GMSMarker()
        //marker.position = CLLocationCoordinate2D(latitude: 37.6281126, longitude: 127.0904568)

    }
    var appDelegate:AppDelegate!
    var locationMgr:CLLocationManager!
    var mapView:GMSMapView!
  
    
    @IBOutlet weak var DoneBtnoutlet: UIBarButtonItem!
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        locationMgr = appDelegate.locationMgr
        locationMgr.delegate = self
        
        if CLLocationManager.authorizationStatus() ==
            .authorizedWhenInUse {
            locationMgr.desiredAccuracy = kCLLocationAccuracyBest
            locationMgr.startUpdatingLocation()
        }
        
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker)-> Bool{
        print(marker.title)
        return true
        
    }
    func locationManger( _manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let camera = GMSCameraPosition.camera(withLatitude:
                location.coordinate.latitude, longitude:
                location.coordinate.longitude, zoom: mapView.camera.zoom)
            mapView.animate(to: camera)
            
        }
 
    }
    
    @IBAction func DoneBtn(_ sender: UIBarButtonItem) {
        NSLog("dkddk")
        NSLog("\(self.address)")
        self.delegate.form.rowBy(tag: "meetArea")!.value = "\(self.address!)"
        self.dismiss(animated: true)
        
    }
}
   

    extension Maps: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        NSLog(place.formattedAddress ?? "")
        GMSPlacesClient.shared().lookUpPlaceID(place.placeID!) { (result, error) in
            NSLog("query in")
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            NSLog("query out")
            debugPrint(result?.coordinate)
            //마커찍기
            if let coordinate = result?.coordinate {
                let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let marker = GMSMarker(position: position)
                marker.title = place.name
                //marker.iconView = markerView
                marker.tracksViewChanges = true
                
                marker.map = self.googlemapsView
                print("Place name: \(place.name)")
                print("Place address: \(result?.formattedAddress)")
                self.address = result?.formattedAddress
                NSLog("address:\(self.address)")
                
                //london = marker
                let camera = GMSCameraPosition.camera(withLatitude:
                    coordinate.latitude, longitude:
                    coordinate.longitude, zoom: 16.0)
                self.googlemapsView.animate(to: camera)
              
            }
             
            self.dismiss(animated: true, completion: nil)
            
               // print("Place address: \(place.formattedAddress)")
            
        }
    }
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    /*
     func updateMap(){
     let camera = GMSCameraPosition.camera(withLatitude:  , longitude: place.longitude, zoom: 16.0)
     self.googlemapsView = GMSMapView(frame: self.GoogleMapController.frame, camera: camera)
     
     //self.GoogleMapsView = GMSMapView(frame: self.GoogleMapController.frame)
     //mapView.isMyLocationEnabled = true
     //mapView.settings.myLocationButton = true
     self.view.addSubview(self.googlemapsView)
     
     //let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
     //mapView.settings.myLocationButton = true
     
     
     let mapView = GMSMapView.map(withFrame: self.GoogleMapController.frame, camera: cameraCenter)
     // self.GoogleMapController.insertSubview(mapView, at: 0)
     mapView.delegate = self
     
     mapView.isMyLocationEnabled = true
     mapView.settings.myLocationButton = true
     
     //let marker = GMSMarker()
     //marker.position = CLLocationCoordinate2D(latitude: 37.6281126, longitude: 127.0904568)
     
     }
     */
    
}

