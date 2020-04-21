//
//  ViewController.swift
//  OnceADayMotivate
//
//  Created by Christopher Meyer on 1/18/20.
//  Copyright © 2020 Christopher Meyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class ViewController: UIViewController {
    
    // A view for when you click on the menu button
    // ** Consider Renaming **
    var transparentView = UIView()
    // The table view used in the main menu.
    // ** Consider Renaming **
    var tableView = UITableView()
    
    // Variable used for the height of the menu. Consider changing variable name.
    // ** Consider Renaming **
    let height: CGFloat = 250
    
    // The text values in the menu. Need to rename these when I decide on the actual menu options
    var menuArray = ["Profile", "Favorite", "Notification", "Change Password", "Logout"]
    
    // This variable displays the image of the day.
    @IBOutlet weak var dailyImage: UIImageView!
    
    // This variable displays the quote of the day
    @IBOutlet weak var dailyQuote: UILabel!
    
    // This variable displays today's date
    @IBOutlet weak var dailyDate: UILabel!
    
    // Firebase Reference
    let db = Firestore.firestore()
    
    var todaysQuote = DailyQuote()
    var previousQuote = DailyQuote()
    var nextQuote = DailyQuote()
    
    var todayDate = Date()
    var previousDate = Date().dayBefore
    var nextDate = Date().dayAfter
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Create a way to show the current date as the text.
        dailyDate.text = todayDate.month + "\n" + todayDate.day

        // Display the Quote Of The Day
        displayTodaysQuote(database: db, dateVal: todayDate.fulldate)
        
        // Get Yesterdays's Quote to be ready
        previousQuote = createQuote(database: db, dateVal: previousDate.fulldate)
        nextQuote = createQuote(database: db, dateVal: nextDate.fulldate)
        
        // Add swipe gestures
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    func updateTheQuoteText() {
        print(todaysQuote.quoteText())
        self.dailyQuote.text = todaysQuote.quoteText()
        self.dailyDate.text = currentDate.month + "\n" + currentDate.day
        previousDate = currentDate.dayBefore
        nextDate = currentDate.dayAfter
        previousQuote = createQuote(database: db, dateVal: previousDate.fulldate)
        nextQuote = createQuote(database: db, dateVal: nextDate.fulldate)

    }
    
    // This function is called during viewDidLoad() to retrieve the quote of the day
    func displayTodaysQuote(database: Firestore, dateVal: String) {
        let firstQuote = DailyQuote()
        todaysQuote.date = dateVal
        let dbRef = database.collection("dailyQuotes")
        dbRef.whereField("date", isEqualTo: dateVal).getDocuments() { (querySnapshot, err) in
            if err != nil {
                firstQuote.quote = "Connectivity Issues"
            } else {
                 for document in querySnapshot!.documents {
                    firstQuote.author = document.get("author") as! String
                    firstQuote.quote = document.get("quote") as! String
                }
                DispatchQueue.main.async {
                    self.dailyQuote.text = firstQuote.quoteText()
                    self.tableView.reloadData()
                }
            }
        }
    
    }
    
    // Function to handle swipe gestures left and ripe
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if(sender.direction == .left) {
            if currentDate.fulldate == todayDate.fulldate {
                print("On current date")
            }
            else {
                print("Swipe Left")
                todaysQuote = nextQuote
                currentDate = nextDate
                updateTheQuoteText()
            }
        }
        
        if(sender.direction == .right) {
            print("Swipe Right")
            todaysQuote = previousQuote
            currentDate = previousDate
            updateTheQuoteText()
        }
    }
    // Function when you click on the menu
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

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    var fulldate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }

}

// Create a Quote
func createQuote(database: Firestore, dateVal: String) -> DailyQuote {
    let todaysQuote = DailyQuote()
    todaysQuote.date = dateVal
    let dbRef = database.collection("dailyQuotes")
    dbRef.whereField("date", isEqualTo: dateVal).getDocuments() { (querySnapshot, err) in
         if err != nil {
            todaysQuote.quote = "Unable to Get Quote"
             } else {
                 for document in querySnapshot!.documents {
                    todaysQuote.author = document.get("author") as! String
                    todaysQuote.quote = document.get("quote") as! String
                    }
             }
     }
    return todaysQuote
}



