//
//  SideMenuViewController.swift
//  MyRide
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import UIKit
import CoreData



class SideMenuViewController: UIViewController, MenuDelegate {

    private var menuView: MenuView!
    private var gestureView: UIView!
    var mapsViewController: MapsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTableView() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        do {
            menuView.history = try managedContext.fetch(fetchRequest)
            menuView.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private func setup() {
        
        view.backgroundColor = UIColor(white: 1, alpha: 0)
        menuView = MenuView(frame: CGRect(x: 0, y: 0, width: 275, height: UIScreen.main.bounds.height))
        menuView.delegate = self
        //mapboxView.delegate = self
        view.addSubview(menuView)
        refreshTableView()
        
        self.gestureView = UIView(frame: CGRect(x: 275, y: 0, width: UIScreen.main.bounds.width - 275, height: UIScreen.main.bounds.height))
        self.gestureView.backgroundColor = UIColor(white: 1, alpha: 0)
        self.gestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SideMenuViewController.hiddenMenu)))
        view.addSubview(self.gestureView)
    }

    public func displayMenu() {
        refreshTableView()
        
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.x = 0
        }
        
        
    }
    
    public func hiddenMenu() {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.x = -self.view.frame.size.width
        }
    }
    
    func clickHistory(address: String, lat: String, lng: String) {
        hiddenMenu()
        self.mapsViewController.updateLocation(address: address, lat: Double(lat)!, lng: Double(lng)!)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
