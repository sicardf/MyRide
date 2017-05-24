//
//  SearchAddressVIew.swift
//  MyRide
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SearchAddressDelegate {
    func editTextField(address: String)
    func getAddressMap(address: String)
    func displayMenu()
}

class SearchAddressView: UIView, UITextFieldDelegate {

    @IBOutlet var view: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIButton!
    
    var delegate: SearchAddressDelegate!
    var result: JSON! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        UINib(nibName: "SearchAddressView", bundle: nil).instantiate(withOwner: self, options: nil)
        frame.size.height = 40
         
        tableView.isHidden = true
        
        textField.placeholder = "Please enter the address"
        textField.addTarget(self, action: #selector(SearchAddressView.editTextField), for: .editingChanged)
        
        menuButton.addTarget(self, action: #selector(SearchAddressView.displayMenu), for: .touchUpInside)
        
        view.frame = self.bounds
        addSubview(view)
    }
    
    private func dismissAutocompletion() {
        self.tableView.isHidden = true
        frame.size.height = 40
        view.frame = self.bounds
    }
    
    private func displayAutocompletion(nbElem: CGFloat) {
        tableView.isHidden = false
        frame.size.height = nbElem * 44 + 40
        view.frame.size.height = nbElem * 44 + 40
        self.tableView.frame.size.height = nbElem * 44
    }
    
    var address: String {
        get {
            return textField.text!
        }
        set (address) {
            textField.text = address
        }
    }

    // MARK: SearchAddressDelegate
    
    func editTextField() {
        delegate.editTextField(address: textField.text!)
    }
    
    func updateAutoCompletion(json: JSON) {
        result = json
        if json["predictions"].count == 0 {
            self.dismissAutocompletion()
        } else {
            displayAutocompletion(nbElem: CGFloat(json["predictions"].count))
        }
        tableView.reloadData()
    }
    
    func displayMenu() {
        delegate.displayMenu()
    }
    
}

extension SearchAddressView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if result != nil {
            return result["predictions"].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ElementCell")
        cell.textLabel?.text = result["predictions"][indexPath.row]["description"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.text = result["predictions"][indexPath.row]["description"].stringValue
        delegate.getAddressMap(address: textField.text!)
        
        self.tableView.isHidden = true
        frame.size.height = 40
        view.frame = self.bounds
    }
}
