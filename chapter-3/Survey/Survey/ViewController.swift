//
//  ViewController.swift
//  Survey
//
//  Created by Hans Yelek on 4/30/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private static let CellIdentifier = "CellIdentifier"
    private static let HeaderIdentifier = "HeaderIdentifier"
    static let MaxItemSize = CGSize(width: 200, height: 200)
    
    private var selectionModelArray: Array<SelectionModel>
    private var currentModelArrayIndex: Int = 0
    private var isFinished: Bool = false

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        selectionModelArray = ViewController.newSelectionModel()
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        selectionModelArray = ViewController.newSelectionModel()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new collection view with our flow layout and set ourself as delegate and data source
        //let surveyCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: surveyFlowLayout)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        // Register classes
        self.collectionView?.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: ViewController.CellIdentifier)
        self.collectionView?.registerClass(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewController.HeaderIdentifier)
        //
        self.collectionView?.opaque = false
        self.collectionView?.backgroundColor = UIColor.blackColor()
        //self.collectionView = surveyCollectionView
    }
    
    // Returns the photo model at any index path
    private func photoModelForIndexPath(indexPath: NSIndexPath) -> PhotoModel? {
        guard indexPath.section < selectionModelArray.count else { return nil }
        guard indexPath.row < selectionModelArray[indexPath.section].photoModels.count else { return nil }

        return selectionModelArray[indexPath.section].photoModels[indexPath.item]
    }

    // Configures a cell for a given index path
    private func configureCell(cell: CollectionViewCell, forIndexPath indexPath: NSIndexPath) {
        if let image = photoModelForIndexPath(indexPath)?.image {
            cell.image = image
        }
        
        cell.setDisabled(false)
        cell.selected = false
        
        // If the cell is not in our current last index, disable it
        if indexPath.section < currentModelArrayIndex {
            cell.setDisabled(true)
            
            // If the cell was selected by the user previously, select it now
            if indexPath.row == selectionModelArray[indexPath.section].selectedPhotoModelIndex {
                cell.selected = true
            }
        }
    }

    private class func newSelectionModel() -> Array<SelectionModel> {
        let modelArray: Array<SelectionModel> = [
        
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("Purple Flower", image: UIImage(named: "0.jpg")),
                PhotoModel.photoModelWithName("WWDC Hypertable", image: UIImage(named: "1.jpg")),
                PhotoModel.photoModelWithName("Purple Flower II", image: UIImage(named: "2.jpg")),
                ]),
        
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("Castle", image: UIImage(named: "3.jpg")),
                PhotoModel.photoModelWithName("Skyward Look", image: UIImage(named: "4.jpg")),
                PhotoModel.photoModelWithName("Kakabeka Falls", image: UIImage(named: "5.jpg")),
                ]),
            
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("Puppy", image: UIImage(named: "6.jpg")),
                PhotoModel.photoModelWithName("Thunder Bay Sunset", image: UIImage(named: "7.jpg")),
                PhotoModel.photoModelWithName("Sunflower I", image: UIImage(named: "8.jpg")),
                ]),
            
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("Sunflower II", image: UIImage(named: "9.jpg")),
                PhotoModel.photoModelWithName("Sunflower I", image: UIImage(named: "10.jpg")),
                PhotoModel.photoModelWithName("Squirrel", image: UIImage(named: "11.jpg")),
                ]),
            
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("Montréal Subway", image: UIImage(named: "12.jpg")),
                PhotoModel.photoModelWithName("Geometrically Intriguing Flower", image: UIImage(named: "13.jpg")),
                PhotoModel.photoModelWithName("Grand Lake", image: UIImage(named: "17.jpg")),
                ]),
            
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("Spadina Subway Station", image: UIImage(named: "15.jpg")),
                PhotoModel.photoModelWithName("Staircase to Grey", image: UIImage(named: "14.jpg")),
                PhotoModel.photoModelWithName("Saint John River", image: UIImage(named: "16.jpg")),
                ]),
            
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("Purple Bokeh Flower", image: UIImage(named: "18.jpg")),
                PhotoModel.photoModelWithName("Puppy II", image: UIImage(named: "19.jpg")),
                PhotoModel.photoModelWithName("Plant", image: UIImage(named: "21.jpg")),
                ]),
            
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("Peggy's Cove I", image: UIImage(named: "21.jpg")),
                PhotoModel.photoModelWithName("Peggy's Cove II", image: UIImage(named: "22.jpg")),
                PhotoModel.photoModelWithName("Sneaky Cat", image: UIImage(named: "23.jpg")),
                ]),
            
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("King Street West", image: UIImage(named: "24.jpg")),
                PhotoModel.photoModelWithName("TTC Streetcar", image: UIImage(named: "25.jpg")),
                PhotoModel.photoModelWithName("UofT at Night", image: UIImage(named: "26.jpg")),
                ]),
            
            SelectionModel.selectionModelWithPhotoModels([
                PhotoModel.photoModelWithName("Mushroom", image: UIImage(named: "27.jpg")),
                PhotoModel.photoModelWithName("Montréal Subway Selective Colour", image: UIImage(named: "28.jpg")),
                PhotoModel.photoModelWithName("On Air", image: UIImage(named: "29.jpg")),
                ]),
        ]
        
        return modelArray
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // Return the smallest of either our current model index plus one, or our total number of sections.
        // This will show one section when we only want to display section zero, etc.
        // It will prevent us from returning 11 when we only have 10 sections.
        return min(currentModelArrayIndex + 1, selectionModelArray.count)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of photos in the section model
        return selectionModelArray[currentModelArrayIndex].photoModels.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewController.CellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewController.HeaderIdentifier, forIndexPath: indexPath) as! CollectionHeaderView
        
        if indexPath.section == 0 {
            // If this is the first header, display a prompt to the user 
            headerView.text = "Tap on a photo to start the recommendation engine."
        } else if indexPath.section <= currentModelArrayIndex {
            // Otherwise, display a prompt using the selected photo from the previous section
            let selectionModel: SelectionModel = selectionModelArray[indexPath.section - 1]
            if let selectedPhotoModel: PhotoModel = photoModelForIndexPath(NSIndexPath(forItem: selectionModel.selectedPhotoModelIndex, inSection: indexPath.section - 1)) {
                headerView.text = "Because you liked \(selectedPhotoModel.name)"
            }
        }
        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // No matter what, deselect cell
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        // Set the selected photo index
        selectionModelArray[currentModelArrayIndex].selectedPhotoModelIndex = indexPath.item
        
        if currentModelArrayIndex >= selectionModelArray.count - 1 {
            // Present some dialogue to indicate things are done.
            isFinished = true
            
            let action = UIAlertAction(title: "Awesome!", style: .Default, handler: nil)
            let alert = UIAlertController(title: "Recommendation Engine", message: "Based on your selections, we have concluded you have excellent taste in photography!", preferredStyle: .Alert)
            alert.addAction(action)
            
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
        collectionView.performBatchUpdates({
            self.currentModelArrayIndex += 1
            self.collectionView?.insertSections(NSIndexSet(index: self.currentModelArrayIndex))
            self.collectionView?.reloadSections(NSIndexSet(index: self.currentModelArrayIndex - 1))
            
            }, completion: { finished in
                collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: self.currentModelArrayIndex), atScrollPosition: .Top, animated: true)
        })
    }
    
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == currentModelArrayIndex && !isFinished
    }
    
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        if action ==  #selector(NSObject.copy(_:)) {
            return true
        }
        return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if action ==  #selector(NSObject.copy(_:)) {
            let pasteboard = UIPasteboard.generalPasteboard()
            pasteboard.string = photoModelForIndexPath(indexPath)?.name 
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // Grab the photo model for the cell
        guard let photoModel: PhotoModel = photoModelForIndexPath(indexPath), image = photoModel.image else { return CGSizeZero }
        
        // Determine the size and aspect ration for the model's image 
        let photoSize = image.size
        let aspectRatio: CGFloat = photoSize.width / photoSize.height
        
        // Start out with the detail image size at maximum size 
        let maxSize: CGSize = ViewController.MaxItemSize
        var itemSize: CGSize = maxSize
        
        if aspectRatio < 1 {
            // The photo is taller than it is wide, so constrain the width
            itemSize = CGSize(width: maxSize.width * aspectRatio, height: maxSize.height)
        } else if aspectRatio > 1 {
            // The photo is wider than it is tall, so constrain the height
            itemSize = CGSize(width: maxSize.width, height: maxSize.height / aspectRatio)
        }
        
        return itemSize
    }
}

