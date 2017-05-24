//
//  SideMenuView.swift
//  MyRide
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import UIKit
import CoreData

protocol MenuDelegate {
    func clickHistory(address: String, lat: String, lng: String)
}

class MenuView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet var tableView: UITableView!
    
    var history: [NSManagedObject] = []
    var delegate: MenuDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        UINib(nibName: "MenuView", bundle: nil).instantiate(withOwner: self, options: nil)
        
        view.frame = self.bounds
        addSubview(view)
    }
    
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("RELOADODOAODA")
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ElementCell")
        cell.textLabel?.text = history[indexPath.row].value(forKeyPath: "address") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.clickHistory(address: (history[indexPath.row].value(forKeyPath: "address") as? String)!,
                              lat: (history[indexPath.row].value(forKeyPath: "lat") as? String)!,
                              lng: (history[indexPath.row].value(forKeyPath: "lng") as? String)!)
    }

}
