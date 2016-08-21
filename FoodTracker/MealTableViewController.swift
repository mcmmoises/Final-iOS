//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/27/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit
import RealmSwift


import MapKit
import CoreLocation

class MealTableViewController: UITableViewController {
    // MARK: Properties
    
    var meals = [Meal]()
    // dabase manager
    var realm:Realm?
    // override contructor
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init Table")
        
        realm = try! Realm()
        print("Path of DB is \(realm?.path)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()

        // Load the sample data.
        loadSampleMeals()
    }
    
    func loadSampleMeals() {
        
        // retrieve data from DataBase
        var listMeals = realm?.objects(MealDB.self)
         var coordinate : CLLocationCoordinate2D?
        
        
        for mealdb in listMeals! {
            print ( "the name is \(mealdb.name)")
            // append to meals array
            let photo = UIImage(data: mealdb.photo!)
            let coord = -0.1
            
            let newMeal = Meal(name: mealdb.name,
                photo: photo,
                rating: mealdb.rating,
                coordenadas: coordinate!   )!
            newMeal.id = mealdb.id
            meals.append(newMeal)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            //let delete  = realm?.objects(MealDB.self).filter("id == \(mealtToDelete.id!)")
            //print("the filter \(delete)")
            //let realm = Realm()
            //let deletedValue = "two"
            
            let mealtToDelete = meals[indexPath.row]
            
            try! realm!.write {
                let deletedNotifications = self.realm!.objects(MealDB.self).filter("id == %@", mealtToDelete.id!)
                self.realm!.delete(deletedNotifications)
            }

            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            print("delete new Meal with ID ")
            //realm?.delete(<#T##object: Object##Object#>)
        
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }
    

    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
    
    struct Variables {
        static var ListMeal = [Meal]()
    }
}