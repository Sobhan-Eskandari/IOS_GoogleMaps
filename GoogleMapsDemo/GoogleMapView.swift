//
//  GoogleMapView.swift
//  GoogleMapsDemo
//
//  Created by Sobhan Eskandari on 11/24/16.
//  Copyright © 2016 Sobhan Eskandari. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import PXGoogleDirections
import GoogleMaps

class GooleMapView: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    func googleDirectionsRequestDidFail(_ googleDirections: PXGoogleDirections, withError error: NSError) {
        NSLog("googleDirectionsRequestDidFail:withError:")
        NSLog("\(error)")
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 37.331690, longitude: -122.030762, zoom: 11.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.331690, longitude:-122.030762)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        let routeIndex = 0
        
        let directionsAPI = PXGoogleDirections(apiKey: "AIzaSyDaKuMOTrKgymjzEvHe_Rz7SDzUIZnvNrQ",
                                               from: PXLocation.coordinateLocation(CLLocationCoordinate2DMake(37.331690, -122.030762)),
                                               to: PXLocation.coordinateLocation(CLLocationCoordinate2DMake(35.110437, -79.728886)))
        
        directionsAPI.calculateDirections({ response in
            switch response {
            case let .error(_, error):
                // Oops, something bad happened, see the error object for more information
                print(error.code)
                break
            case let .success(request, routes):
                // Do your work with the routes object array here
                for i in 0 ..< routes.count {
                    if i != routeIndex {
                        routes[i].drawOnMap(mapView, approximate: false, strokeColor: UIColor.lightGray, strokeWidth: 3.0)
                    }
                }
                mapView.animate(with: GMSCameraUpdate.fit(routes[routeIndex].bounds!, withPadding: 40.0))
                routes[routeIndex].drawOnMap(mapView, approximate: false, strokeColor: UIColor.purple, strokeWidth: 4.0)
                routes[routeIndex].drawOriginMarkerOnMap(mapView, title: "Origin", color: UIColor.green, opacity: 1.0, flat: true)
                routes[routeIndex].drawDestinationMarkerOnMap(mapView, title: "Destination", color: UIColor.red, opacity: 1.0, flat: true)
                
                break
            }
        })

    }
}
