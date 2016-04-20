//
//  Flowable.swift
//  Papers
//
//  Created by Tomer Buzaglo on 19/04/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class Flowable: UICollectionViewFlowLayout {
    var appearingIndexPath: NSIndexPath?
    var disAppearingIndexPaths:[NSIndexPath]?
    //we have a reference to the collectionView
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        //get the attributes from the super class
        let attr = super.initialLayoutAttributesForAppearingItemAtIndexPath(
            itemIndexPath)!

        guard appearingIndexPath != nil else {return attr}
        if appearingIndexPath == itemIndexPath {
            attr.alpha = 1.0
            attr.center = CGPoint(x: CGRectGetWidth(collectionView!.frame) / 2, y: 0)
            attr.transform = CGAffineTransformMakeScale(1.2, 1.2) // 5
            attr.zIndex = 99
        }

        return attr
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

        let attrs = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        
        guard let dis = disAppearingIndexPaths where dis.contains(itemIndexPath) else { return attrs}
        
        
        attrs?.size = CGSizeZero
        attrs?.alpha = 1
        attrs?.center = collectionView?.center ?? CGPointZero
        return attrs
    }
}
