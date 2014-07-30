//
//  CollectionViewTripletLayout.swift
//  SwiftCollectionViewTripletLayout
//
//  Created by Aaron McDaniel on 7/26/14.
//

import Foundation
import UIKit

@objc protocol SwiftCollectionViewDelegateTripletLayout: UICollectionViewDelegateFlowLayout {

    @optional func collectionView(collectionView: UICollectionView!, sizeForLargeItemsInSection largeItemsSize: Int) -> CGSize
    @optional func insetsForCollectionView(collectionView: UICollectionView!) -> UIEdgeInsets
    @optional func sectionSpacingForCollectionView(collectionView: UICollectionView!) -> CGFloat
    @optional func minimumInteritemSpacingForCollectionView(collectionView: UICollectionView!) -> CGFloat
    @optional func minimumLineSpacingForCollectionView(collectionView: UICollectionView!) -> CGFloat
    
}

class SwiftCollectionViewTripletLayout: UICollectionViewFlowLayout {
    
    var largeCellSize: CGSize = CGSize(width: 0, height: 0)
    var smallCellSize: CGSize = CGSize(width: 0, height: 0)
    
    var numberOfCells: NSInteger = 0
    var numberOfLines: CGFloat = 0.0
    var itemSpacing: CGFloat = 0.0
    var lineSpacing: CGFloat = 0.0
    var sectionSpacing: CGFloat = 0.0
    var collectionViewSize: CGSize = CGSize(width: 0, height: 0)
    var insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var oldRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var oldArray: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var largeCellSizeArray: [CGSize] = Array(count: 20, repeatedValue: CGSize(width: 0, height: 0))
    var smallCellSizeArray: [CGSize] = Array(count: 20, repeatedValue: CGSize(width: 0, height: 0))
    var delegate: SwiftCollectionViewDelegateTripletLayout? {
        get {
            return self.collectionView.delegate as? SwiftCollectionViewDelegateTripletLayout
        }
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        collectionViewSize = self.collectionView.bounds.size
        
        itemSpacing = 0
        lineSpacing = 0
        sectionSpacing = 0
        insets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        if let delegate = self.collectionView?.delegate as? SwiftCollectionViewDelegateTripletLayout {
            itemSpacing = delegate.minimumInteritemSpacingForCollectionView!(collectionView)
            lineSpacing = delegate.minimumLineSpacingForCollectionView!(collectionView)
            sectionSpacing = delegate.sectionSpacingForCollectionView!(collectionView)
            insets = delegate.insetsForCollectionView!(collectionView)
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        var contentSize = CGSizeMake(collectionViewSize.width, 0)
        
        for var index = 0; index < self.collectionView.numberOfSections(); ++index {
            var numberOfLines = ceil(CGFloat(self.collectionView.numberOfItemsInSection(index)) / CGFloat(3))
            
            var largeCellHeight:CGFloat = 0
            if !largeCellSizeArray.isEmpty && index < largeCellSizeArray.count {
                largeCellHeight = largeCellSizeArray[index].height
            }
            
            var lineHeight = numberOfLines * (largeCellHeight + lineSpacing) - lineSpacing
            contentSize.height += lineHeight
        }
        
        contentSize.height += CGFloat(insets.top) + CGFloat(insets.bottom) + CGFloat(sectionSpacing) * (CGFloat(collectionView.numberOfSections()) - 1)
        var numberOfItemsInLastSection = collectionView.numberOfItemsInSection(collectionView.numberOfSections() - 1)

        if ((numberOfItemsInLastSection - 1) % 3 == 0 && (numberOfItemsInLastSection - 1) % 6 != 0) {
            contentSize.height -= smallCellSizeArray[collectionView.numberOfSections() - 1].height + itemSpacing
        }
        
        return contentSize
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]! {
        var shouldUpdate = shouldUpdateAttributesArray()
        
        if(CGRectEqualToRect(oldRect, rect) && !shouldUpdate) {
            return oldArray
        }
        
        oldRect = rect
        var attributesArray = [UICollectionViewLayoutAttributes]()
        for var index = 0; index < collectionView.numberOfSections(); ++index {
            var numberOfCellsInSection = collectionView.numberOfItemsInSection(index)
            
            for var nestedIndex = 0; nestedIndex < numberOfCellsInSection; ++nestedIndex {
                var indexPath = NSIndexPath(forItem: nestedIndex, inSection: index)
                var attributes = layoutAttributesForItemAtIndexPath(indexPath)
                if CGRectIntersectsRect(rect, attributes.frame) {
                    attributesArray.append(attributes)
                }
            }
        }
        
        oldArray = attributesArray
        return attributesArray
    }
    
    func shouldUpdateAttributesArray() -> Bool {
        return false
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes! {
        var attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        var largeCellSideLength: CGFloat = (2.0 * (collectionViewSize.width - insets.left - insets.right) - itemSpacing) / 3.0
        var smallCellSideLength: CGFloat = (largeCellSideLength - itemSpacing) / 2.0
        
        largeCellSize = CGSizeMake(largeCellSideLength, largeCellSideLength)
        smallCellSize = CGSizeMake(smallCellSideLength, smallCellSideLength)

        if let localDelegate = self.collectionView?.delegate as? SwiftCollectionViewDelegateTripletLayout {
            var size1: CGSize = localDelegate.collectionView!(collectionView, sizeForLargeItemsInSection: indexPath.section)
            if(!CGSizeEqualToSize(size1, CGSizeZero)) {
                largeCellSize = size1
                smallCellSize = CGSizeMake(collectionViewSize.width - largeCellSize.width - itemSpacing - insets.left - insets.right, (largeCellSize.height / 2.0) - (itemSpacing / 2.0))
            }
        }
       
        largeCellSizeArray[indexPath.section] = largeCellSize
        smallCellSizeArray[indexPath.section] = smallCellSize
        
        var sectionHeight: CGFloat = 0
        for var index = 0; index <= indexPath.section - 1; ++index {
            var cellsCount = collectionView.numberOfItemsInSection(index)
            
            var largeCellHeight = largeCellSizeArray[index].height
            var smallCellHeight = smallCellSizeArray[index].height
            var lines: CGFloat = CGFloat(ceilf(Float(cellsCount) / 3.0))
            sectionHeight += lines * (lineSpacing + largeCellHeight) + sectionSpacing
            if (cellsCount - 1) % 3 == 0 && (cellsCount - 1) % 6 != 0 {
                sectionHeight -= smallCellHeight + itemSpacing
            }
        }
        
        if sectionHeight > 0 {
            sectionHeight -= lineSpacing
        }
        
        var line = indexPath.item / 3
        var lineSpaceForIndexPath: CGFloat = lineSpacing * CGFloat(line)
        var lineOriginY = largeCellSize.height * CGFloat(line) + sectionHeight + lineSpaceForIndexPath + insets.top
        var rightSideLargeCellOriginX = collectionViewSize.width - largeCellSize.width - insets.right
        var rightSideSmallCellOriginX = collectionViewSize.width - smallCellSize.width - insets.right

        if (indexPath.item % 6 == 0) {
            attribute.frame = CGRectMake(insets.left, lineOriginY, largeCellSize.width, largeCellSize.height)
        }else if ((indexPath.item + 1) % 6 == 0) {
            attribute.frame = CGRectMake(rightSideLargeCellOriginX, lineOriginY, largeCellSize.width, largeCellSize.height)
        }else if (line % 2 == 0) {
            if (indexPath.item % 2 != 0) {
                attribute.frame = CGRectMake(rightSideSmallCellOriginX, lineOriginY, smallCellSize.width, smallCellSize.height)
            }else {
                attribute.frame = CGRectMake(rightSideSmallCellOriginX, lineOriginY + smallCellSize.height + itemSpacing, smallCellSize.width, smallCellSize.height)
            }
        }else {
            if (indexPath.item % 2 != 0) {
                attribute.frame = CGRectMake(insets.left, lineOriginY, smallCellSize.width, smallCellSize.height)
            }else {
                attribute.frame = CGRectMake(insets.left, lineOriginY + smallCellSize.height + itemSpacing, smallCellSize.width, smallCellSize.height)
            }
        }
        return attribute
    }
}


