//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/23/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit
import RealmSwift
import MapKit
import CoreLocation

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
CLLocationManagerDelegate {
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    // DB manager
    var realm:Realm?
    
    /*
        This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
        or constructed as part of adding a new meal.
    */
    var meal: Meal?
    var coordinate : CLLocationCoordinate2D?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // init DB Manager
        realm = try! Realm()
        print("the Path is \(realm!.path)")
        
        // last version Path ---> realm?.configuration.fileURL
        //print("the Path is \(realm.))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidMealName()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 1.0
        map.addGestureRecognizer(longPress)
    }
    
    //Mapa
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    
    override func viewWillAppear(animated: Bool) {
        // Init CoreLocation
        // Inicia el delegado para escuchar la posición del GPS
        self.locationManager.delegate = self
        //Activacion del GPS
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //Inicia como tal el GPS
        self.locationManager.startUpdatingLocation()
        //self.mapView.showsUserLocation = true
    }
    
    //Esta funcion sirve para tener todos los datos del GPS
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        //se saca la latitud y longitud del dispositivo
        currentLocation = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let myLocationPointRect = MKMapRectMake(currentLocation.latitude, currentLocation.longitude, 0, 0)
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(currentLocation, theSpan)
        map.setRegion(theRegion, animated: true)
        
        var anotation = MKPointAnnotation()
        anotation.coordinate = currentLocation
        anotation.title = "The Location"
        anotation.subtitle = "This is the location !!!"
        map.addAnnotation(anotation)
        
        map.addAnnotation(anotation)
        var zoomRect = myLocationPointRect
        print("the current location is \(currentLocation.longitude) , \(currentLocation.latitude)")
        
        //termina el trackeo del GPS sino sigue sacando puntos
        self.locationManager.stopUpdatingLocation()
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        var touchPoint = gestureRecognizer.locationInView(self.map)
        var newCoord:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        var newAnotation = MKPointAnnotation()
        
        newAnotation.coordinate = newCoord
        newAnotation.title = nameTextField.text  //"New Location"
        //newAnotation.subtitle = "New Subtitle"
        map.addAnnotation(newAnotation)
        
        print(newCoord.latitude)
        
        coordinate = CLLocationCoordinate2D(latitude: newCoord.latitude, longitude: newCoord.longitude)
        
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            //let coord: CLLocationCoordinate2D = coordinate!
            let coord = 0.1
            // Set the meal to be passed to MealListTableViewController after the unwind segue.
            meal = Meal(name: name, photo: photo, rating: rating, coordenadas: coordinate! )
            
            // save new Meal
            var newMealDB = MealDB()
            newMealDB.name = (meal?.name)!
            // convert to NSData
            newMealDB.photo =   UIImagePNGRepresentation((meal?.photo)!)
            
            newMealDB.rating = (meal?.rating)!
            
            //newMealDB.la = (meal?.coordenadas)!
            // generate ID
            newMealDB.id = NSUUID().UUIDString
            
            // save in to DB
            try! realm?.write{
                // save new object
                self.realm?.add(newMealDB)
            }
            
            
        }
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

}

