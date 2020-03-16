//
//  CustomeTableViewCell.swift
//  OnceADayMotivate
//
//  Created by Christopher Meyer on 3/15/20.
//  Copyright © 2020 Christopher Meyer. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    // This is the background color of the cell
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x:0, y:0, width: self.frame.width, height: 50))
            return view
    }()
    
    // This is the Image in the menu bar
    lazy var settingImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x:15, y:10, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
            return imageView
    }()
    
    // This is the label
    lazy var lbl: UILabel = {
        let lbl = UILabel(frame: CGRect(x:60, y: 10, width: self.frame.width - 80, height: 30))
            return lbl
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(settingImage)
        backView.addSubview(lbl)
        // Configure the view for the selected state
    }

}
