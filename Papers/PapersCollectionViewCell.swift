//
//  PapersCollectionViewCell.swift
//  Papers
//
//  Created by Tomer Buzaglo on 19/04/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PapersCollectionViewCell: UICollectionViewCell {
    //MARK: Outlets
    @IBOutlet weak var deleteImageView: UIImageView!
    var paper:Paper?{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var paperImageView: UIImageView!
    
    //update UI
    func updateUI(){
        paperImageView?.image = UIImage(named: paper?.imageName ?? "")
        label?.text = paper?.caption
    }
    
    //MARK: Moving cells
    //In the view Controller we add a 1 Gesture recognizer for the collection view
    var moving:Bool = false{
        didSet{
            self.hidden = moving
        }
    }
    
    //computed property for the snapshot UIView
    var snapshot:UIView{
        let snapshot:UIView = snapshotViewAfterScreenUpdates(true)
        let layer = snapshot.layer
        layer.masksToBounds = false //take advantage of shadow (Depth)
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: -5, height: -5)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.4
        return snapshot
    }
    
    //MARK: Deleting selected cells in editing mode
    var editing : Bool = false {
        didSet{
            deleteImageView.hidden = !editing
        }
    }
    
    override var selected: Bool{
        didSet{
            if editing {
                deleteImageView.image = UIImage(named: selected ? "Checked":"Unchecked")
            }
        }
    }
    
    
    
    
    
    //    override func prepareForReuse() {
    //        super.prepareForReuse()
    //    }
    //    override func didMoveToSuperview() {
    //        super.didMoveToSuperview()
    //        updateUI()
    //    }
    
    //     var backgroundView: UIView?
    //     var selectedBackgroundView: UIView?
    //     var contentView: UIView
    
}
