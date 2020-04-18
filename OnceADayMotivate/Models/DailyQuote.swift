//
//  DailyQuote.swift
//  OnceADayMotivate
//
//  Created by Christopher Meyer on 4/12/20.
//  Copyright © 2020 Christopher Meyer. All rights reserved.
//

import UIKit
import Firebase

class DailyQuote {
    var author = ""
    var quote = ""
    var date = ""


    func quoteText() -> String {
        return ("\"" + quote + "\"\n\n -" + author)
    }
    
    func updateQuote(database: Firestore){
        let dbRef = database.collection("dailyQuotes")
        dbRef.whereField("date", isEqualTo: date).getDocuments() { (querySnapshot, err) in
             if err != nil {
                self.quote = "Unable to Get Quote"
                print("Failed to get the item")
                } else {
                    for document in querySnapshot!.documents {
                        print("Checking for date" + self.date)
                        self.author = document.get("author") as! String
                        self.quote = document.get("quote") as! String
                        print("Retrieved author " + self.author)
                        print("And quote " + self.quote)
                        
                     }
                 }
         }

    }
}
