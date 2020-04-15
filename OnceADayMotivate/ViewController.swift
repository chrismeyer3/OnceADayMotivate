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
    var db: Firestore!
    
    var todaysQuote = DailyQuote()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Create a way to show the current date as the text.
        
        let todayDate = Date()
        let todayMonth = todayDate.month
        let todayDay = todayDate.day
        dailyDate.text = todayMonth + "\n" + todayDay
        let todayFullDate = todayDate.fulldate
        
        // Firestore things
        // This calls the Database to grab the current date's quote to set it as the initial loading image
        db = Firestore.firestore()
        //let todaysQuote = createQuote(database: db, dateVal: todayFullDate)
        //self.dailyQuote.text = "Fetching Quote"
        //self.dailyQuote.text = todaysQuote.quoteText()
        //let todaysQuote =  DailyQuote()
        todaysQuote.date = todayFullDate
        todaysQuote.updateQuote(database: db)
        DispatchQueue.main.async {
            print("Attempting dispatch queue")
            self.dailyQuote.text = self.todaysQuote.quoteText()
            self.updateTheQuoteText()
        }
        print("Loaded the UI")
        //updateTheQuoteText()
        //self.dailyQuote.reloadInputViews()
        

        
        //let dbReference = db.collection("dailyQuotes")
//        dbRef.whereField("date", isEqualTo: todayFullDate).getDocuments() { (querySnapshot, err) in
//            if err != nil {
//                    self.dailyQuote.text = "Unable to Get Quote"
//                } else {
//                    for document in querySnapshot!.documents {
//                        let quoteVal = document.get("quote") as! String
//                        let authorVal = document.get("author") as! String
//                        self.dailyQuote.text = quoteVal + "\n\n -" + authorVal
//                    }
//                }
//        }
      //  self.dailyQuote.text = getQuoteFromDate(db: db, dateVal: todayFullDate)
        // Use this code to get a document based on its specific value
//        let docRef = db.collection("dailyQuotes").document("85pbGVqSUjUAnS6D4G2x")
//        docRef.getDocument { (document, error) in
//             if let document = document, document.exists {
//                 let docData = document.data()
//               // self.dailyQuote.text = docData?["quote"] as? String
//                let quoteVal = docData?["quote"] as! String
//                let authorVal = docData?["author"] as! String
//                self.dailyQuote.text = quoteVal + "\n\n -" + authorVal
//              } else {
//                 print("Document does not exist")
//
//              }
//        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateTheQuoteText()
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
    
    func updateTheQuoteText() {
        print(todaysQuote.quoteText())
        self.dailyQuote.text = todaysQuote.quoteText()
        print(self.dailyQuote.text)
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
}

//func getQuoteFromDate(database: Firestore, dateVal: String) -> String {
//    var dailyQuoteText = "Quote Text Base"
//    let dbRef = database.collection("dailyQuotes")
//    dbRef.whereField("date", isEqualTo: dateVal).getDocuments() { (querySnapshot, err) in
//         if err != nil {
//                dailyQuoteText = "Unable to Get Quote"
//                print("Failed to get the item")
//             } else {
//                 for document in querySnapshot!.documents {
//                    print("Checking for date" + dateVal)
//                    let quoteVal = document.get("quote") as! String
//                    let authorVal = document.get("author") as! String
//                    dailyQuoteText = quoteVal + "\n\n -" + authorVal
//                    print("Writing the quote " + dailyQuoteText)
//                 }
//             }
//     }
//    print("Returning the quote " + dailyQuoteText)
//    return dailyQuoteText
//}

func createQuote(database: Firestore, dateVal: String) -> DailyQuote {
    let todaysQuote = DailyQuote()
    //let dispatchGroup = DispatchGroup()
    //dispatchGroup.enter()
    todaysQuote.date = dateVal
    let dbRef = database.collection("dailyQuotes")
    dbRef.whereField("date", isEqualTo: dateVal).getDocuments() { (querySnapshot, err) in
         if err != nil {
            todaysQuote.quote = "Unable to Get Quote"
                print("Failed to get the item")
                //dispatchGroup.leave()
             } else {
                 for document in querySnapshot!.documents {
                    print("Checking for date" + dateVal)
                    todaysQuote.author = document.get("author") as! String
                    todaysQuote.quote = document.get("quote") as! String
                    print("Retrieved author " + todaysQuote.author)
                    print("And quote " + todaysQuote.quote)
                    //dispatchGroup.leave()
                    
                 }
             }
     }
    return todaysQuote
}



