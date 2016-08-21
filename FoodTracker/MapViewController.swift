//
//  MapViewController.swift
//  FoodTracker
//
//  Created by Diego Alejandro Orellana Lopez on 8/20/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//



import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var meals : [Meal]?
    var test: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(test)
        
        // Do any additional setup after loading the view.
        
        //meals = (tabBarController as! MealsTabControllerViewController).meals
        print("  \(meals)")
        
        
        //let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        //let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 45.612125, longitude: 22.948280)
        
        //let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        
        
        //mapView.setRegion(theRegion, animated: true)
        
        //var anotation = MKPointAnnotation()
        ///anotation.coordinate = location
        //anotation.title = "The Location"
        //anotation.subtitle = "This is the location !!!"
        //mapView.addAnnotation(anotation)
        
        
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
        
        
        //let string = MyVariables.yourVariable
        //var secondTab = self.tabBarController?.viewControllers![3] as! MealTableViewController
        //meals = secondTab.meals
        //print("Rodrigo \(meals)")
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("1")
        
        let ml = MealTableViewController.Variables.ListMeal
        
        
        print("Lista \(ml)")
        
        
        for item: Meal in ml {
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (item.coordenadas?.latitude)!, longitude: (item.coordenadas?.longitude)!)
            
            let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
            
            
            mapView.setRegion(theRegion, animated: true)
            
            var anotation = MKPointAnnotation()
            anotation.coordinate = location
            anotation.title = item.name
            anotation.subtitle = item.name
            mapView.addAnnotation(anotation)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("Rodrigo2")
    }
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MapViewController, meals = sourceViewController.meals {
            // Add a new meal item.
            print(meals.count)
            print("---------")
        }
    }
    
    /*func action(gestureRecognizer:UIGestureRecognizer) {
    var touchPoint = gestureRecognizer.locationInView(self.mapView)
    var newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
    
    var newAnotation = MKPointAnnotation()
    
    newAnotation.coordinate = newCoord
    newAnotation.title = "New Location"
    newAnotation.subtitle = "New Subtitle"
    mapView.addAnnotation(newAnotation)
    
    }*/
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

