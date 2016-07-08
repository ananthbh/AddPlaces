import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!

    @IBOutlet var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activeplace == -1
        {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        }
        else
        {
            let latitude = NSString(string: places[activeplace]["lat"]!).doubleValue
            
            let longitude = NSString(string: places[activeplace]["lon"]!).doubleValue
            
            var location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            var latdelta:CLLocationDegrees = 0.01
            var londelta:CLLocationDegrees = 0.01
            var span:MKCoordinateSpan = MKCoordinateSpanMake(latdelta, londelta)
            var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            self.map.setRegion(region, animated: true)
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = places[activeplace]["name"]
            self.map.addAnnotation(annotation)
            
        }
        
            
        var longpress = UILongPressGestureRecognizer(target: self, action: "actions:")
        longpress.minimumPressDuration = 2
        map.addGestureRecognizer(longpress)
        
    }
    
    func actions(gesturerecognizer:UIGestureRecognizer) {
        if gesturerecognizer.state == UIGestureRecognizerState.Began
        {
            var touchpoint = gesturerecognizer.locationInView(self.map)
            var newcoordinate = self.map.convertPoint(touchpoint, toCoordinateFromView: self.map)
            var locationa = CLLocation(latitude: newcoordinate.latitude, longitude: newcoordinate.longitude)
            
        CLGeocoder().reverseGeocodeLocation(locationa, completionHandler: { (placemarks, error) in
              var title = ""
            if (error == nil)
            {
                if let p = placemarks?[0]
                {
                    var subthoroughfare:String = ""
                    var throughfare:String = ""
                    
                    if p.subThoroughfare != nil
                    {
                        subthoroughfare = p.subThoroughfare!
                    }
                    if p.thoroughfare != nil
                    {
                        throughfare = p.thoroughfare!
                    }
                    
                    title = "\(subthoroughfare) \(throughfare)"
                }
                
                
                
            }
            
            if title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
            {
                title = "Added \(NSDate())"
            }
            
            places.append(["name":title,"lat":"\(newcoordinate.latitude)","lon":"\(newcoordinate.longitude)"])
            
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = newcoordinate
            annotation.title = title
            self.map.addAnnotation(annotation)
    
            
            
        })
            
        
            
        }
    }
    
    
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var userlocation:CLLocation = locations[0]
        
        var latitude = userlocation.coordinate.latitude
        var longitude = userlocation.coordinate.longitude
        var location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        var latdelta:CLLocationDegrees = 0.01
        var londelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latdelta, londelta)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

