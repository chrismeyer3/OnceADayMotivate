//
//  ViewController.swift
//  OnceADayMotivate
//
//  Created by Christopher Meyer on 1/18/20.
//  Copyright © 2020 Christopher Meyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var transparentView = UIView()
    var tableView = UITableView()
    
    // Variable used for the height of the menu. Consider changing variable name.
    let height: CGFloat = 250
    
    var menuArray = ["Profile", "Favorite", "Notification", "Change Password", "Logout"]
    
    @IBOutlet weak var dailyImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
        
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.height, height: height)
        window?.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: screenSize.height)
        }, completion: nil)
        

    }
    
    @objc func onClickTransparentView(){
        let screenSize = UIScreen.main.bounds.size
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height)
        }, completion: nil)
    }
    

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {fatalError("Unable to dequeue")}
        cell.lbl.text = menuArray[indexPath.row]
        cell.settingImage.image = UIImage(named: menuArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
