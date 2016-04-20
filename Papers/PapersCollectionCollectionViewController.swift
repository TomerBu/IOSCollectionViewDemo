//
//  PapersCollectionCollectionViewController.swift
//  Papers
//
//  Created by Tomer Buzaglo on 19/04/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit


class PapersCollectionCollectionViewController: UICollectionViewController {
    
    private var snapshot: UIView?
    private var sourceIndexPath:NSIndexPath?
    
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    private var paperDataSource = PapersDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem =  self.editButtonItem()
        //self.editing = true / false
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        let width = (CGRectGetWidth(collectionView!.frame) - 3 * 3) / 3
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 3
        layout.itemSize = CGSize(width: width, height: width)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addItem))
        // Do any additional setup after loading the view.
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView?.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer){
        if editing {return}
        
        let location:CGPoint = recognizer.locationInView(collectionView)
        let indexPath = collectionView?.indexPathForItemAtPoint(location)
        
        switch recognizer.state {
        case .Began:
            sourceIndexPath = indexPath
            guard let indexPath = indexPath else {break}
            let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! PapersCollectionViewCell
            snapshot = cell.snapshot
            updateSnapshotView(cell.center, transform: CGAffineTransformIdentity, alpha: 0)
            collectionView?.addSubview(snapshot!)
            UIView.animateWithDuration(0.1, animations: {
                self.updateSnapshotView(cell.center, transform: CGAffineTransformMakeScale(1.1, 1.1), alpha: 0.95)
                cell.moving = true
            })
        case .Changed:
            snapshot?.center = location
            if let path = indexPath{
                paperDataSource.movePaperAtIndexPath(sourceIndexPath!, toIndexPath: path)
                collectionView?.moveItemAtIndexPath(sourceIndexPath!, toIndexPath: path)
                sourceIndexPath = path
            }
        default:
            let cell = collectionView?.cellForItemAtIndexPath(sourceIndexPath!) as! PapersCollectionViewCell
            UIView.animateWithDuration(0.3, animations: {
                self.updateSnapshotView(cell.center, transform: CGAffineTransformIdentity, alpha: 0)
                cell.moving = false
            }){
                _ in
                self.snapshot?.removeFromSuperview()
                self.snapshot = nil
            }
        }
    }
    
    
    func addItem(sender:UIBarButtonItem){
        let idx = paperDataSource.indexPathForNewRandomPaper()
        let layout = self.collectionViewLayout as! Flowable
        layout.appearingIndexPath = idx
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.collectionView?.insertItemsAtIndexPaths([idx])
        }) {_ in}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? DetailViewController{
            dest.paper = (sender as? Paper)
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return paperDataSource.numberOfSections
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paperDataSource.numberOfPapersInSection(section)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PaperCell", forIndexPath: indexPath) as! PapersCollectionViewCell
        
        // Configure the cell
        cell.editing = editing
        cell.paper = paperDataSource.paperForItemAtIndexPath(indexPath)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if editing {
            return
        }
        
        let data = paperDataSource.paperForItemAtIndexPath(indexPath)
        performSegueWithIdentifier("MasterToDetail", sender: data)
    }
    
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.navigationController?.setToolbarHidden(!editing, animated: true)
        collectionView?.allowsMultipleSelection = editing
        
        collectionView?.indexPathsForVisibleItems().forEach({ (indexPath) in
            let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as? PapersCollectionViewCell
            collectionView?.deselectItemAtIndexPath(indexPath, animated: false)
            cell?.editing = editing
        })
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "PaperHeader", forIndexPath: indexPath) as! SectionHeaderCollectionReusableView
        
        headerView.data = paperDataSource.titleForSectionAtIndexPath(indexPath)
        headerView.imageView.image = UIImage(named: headerView.data!)
        return headerView
    }
    
    @IBAction func deleteItems(sender: UIBarButtonItem) {
        if let paths = collectionView?.indexPathsForSelectedItems(){
            paperDataSource.deleteItemsAtIndexPaths(paths)
            
            if let flow = collectionViewLayout as? Flowable{
                flow.disAppearingIndexPaths = paths
            }
            
            collectionView?.deleteItemsAtIndexPaths(paths)
        }
    }
    
    private func updateSnapshotView(center:CGPoint, transform:CGAffineTransform, alpha:CGFloat){
        snapshot?.center = center
        snapshot?.transform = transform
        snapshot?.alpha = alpha
    }
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
