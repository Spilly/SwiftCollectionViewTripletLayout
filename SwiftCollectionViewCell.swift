//
//  SwiftCollectionViewCell.swift
//  SwiftCollectionViewTripletLayout
//
//  Created by Aaron McDaniel on 7/28/14.
//

import Foundation
import UIKit

class SwiftCollectionViewCell : UICollectionViewCell {
    var imageView: UIImageView = UIImageView()
    
    init(coder aDecoder: NSCoder!) {
        
        super.init(coder: aDecoder)

        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    }
    
    
}