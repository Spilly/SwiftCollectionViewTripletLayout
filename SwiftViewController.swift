//
//  SwiftViewController.swift
//  SwiftCollectionViewTripletLayout
//
//  Created by Aaron McDaniel on 7/26/14.
//

import UIKit

class SwiftViewController: UIViewController, SwiftCollectionViewDelegateTripletLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView
    var photosArray: [UIImage] = [UIImage]()

    @IBAction func refresh(UIBarButtonItem) {
        setupPhotosArray()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        collectionView.delegate = self
        collectionView.dataSource = self
        setupPhotosArray()
    }

    func setupPhotosArray() {
        photosArray.removeAll(keepCapacity: false)

        for var i = 1; i <= 20; ++i {
            var photoName = NSString(format: "photos/%ld.jpg", i)
            var photo = UIImage(named: photoName)
            
            if photo != nil {
                photosArray.append(photo)
            }
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        return photosArray.count;
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        if (indexPath.section == 0) {
            var cellID = "headerCell";
            var cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as UICollectionViewCell
            return cell;
        }
        else {
            var cellID = "cellID"
            var cell: SwiftCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as SwiftCollectionViewCell
            cell.imageView.removeFromSuperview()
            cell.imageView.frame = cell.bounds
            cell.imageView.image = photosArray[indexPath.item]
            cell.contentView.addSubview(cell.imageView)
            return cell;
        }
    }

    func sectionSpacingForCollectionView(collectionView: UICollectionView!) -> CGFloat {
        return 5.0
    }

    func minimumInteritemSpacingForCollectionView(collectionView: UICollectionView!) -> CGFloat {
        return 5.0
    }

    func minimumLineSpacingForCollectionView(collectionView: UICollectionView!) -> CGFloat {
        return 5.0
    }

    func insetsForCollectionView(collectionView: UICollectionView!) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5.0, 0, 5.0, 0)
    }
    
    func collectionView(collectionView: UICollectionView!, sizeForLargeItemsInSection largeItemsSize: Int) -> CGSize {
        if (largeItemsSize == 0) {
            return CGSizeMake(320, 200)
        }
        
        return CGSizeZero //same as default !
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}