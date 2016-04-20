//
//  SectionHeaderCollectionReusableView.swift
//  Papers
//
//  Created by Tomer Buzaglo on 19/04/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var imageView: UIImageView!
    
    var data:String?{
        didSet{
            sectionTitleLabel?.text = data
        }
    }
    @IBOutlet weak var sectionTitleLabel: UILabel!
}
