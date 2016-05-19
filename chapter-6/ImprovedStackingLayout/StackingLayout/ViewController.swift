//
//  ViewController.swift
//  StackingLayout
//
//  Created by Hans Yelek on 5/13/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

enum PhotoSection: Int {
    
    case Popular = 0
    case Editors
    case Upcoming
    case Number
}

class ViewController: UIViewController {
    
    private static let numberOfSections = 3
    private static let cellIdentifier   = "Cell Identifier"
    private static let headerIdentifier = "Header Identifier"
    
    private let flowLayout      = CollectionViewFlowLayout()
    private let stackLayout     = CollectionViewStackedLayout()
    private let coverFlowLayout = CoverFlowFlowLayout()
    
    private let collectionView: UICollectionView
    
    private var popularPhotos   = [UIImage]()
    private var editorsPhotos   = [UIImage]()
    private var upcomingPhotos  = [UIImage]()
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: ViewController.cellIdentifier)
        //collectionView.registerClass(CollectionViewHeaderView.self, forCellWithReuseIdentifier: ViewController.headerIdentifier)
        collectionView.registerClass(CollectionViewHeaderView.self, forSupplementaryViewOfKind: CollectionViewHeaderView.kind, withReuseIdentifier: ViewController.headerIdentifier)
    }
    
    private func setupPinchGestureRecognizer() {
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        collectionView.addGestureRecognizer(pinchRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: stackLayout)
        super.init(coder: aDecoder)
        
        setupCollectionView()
        setupPinchGestureRecognizer()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: stackLayout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupCollectionView()
        setupPinchGestureRecognizer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(collectionView)
        collectionView.constrainEdgesToContainer()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let block: PXRequestCompletionBlock /*(Dictionary<String, AnyObject>, NSError) -> Void*/ = { results, error in
        
            var section = -1
            
            if let feature: String = results["feature"] as? String {
                switch feature {
                case "popular"://PhotoSection.Popular:
                    section = PhotoSection.Popular.rawValue
                case "editors"://PhotoSection.Editors:
                    section = PhotoSection.Editors.rawValue
                case "upcoming"://PhotoSection.Upcoming:
                    section = PhotoSection.Upcoming.rawValue
                default:
                    print("Feature: \(feature)")
                }
            }
            
            var item = 0
            guard let photos = results["photos"] as? [Dictionary<String, AnyObject>] else { return }
            
            for photo in photos {
                
                guard let image = photo["images"]?.lastObject else { return }
                guard let url = image?.valueForKey("url") as? String  else { return }

                
                AFImageDownloader(URLString: url, autoStart: true, completion:  { decompressedImage in
                    
                    switch section {
                    case PhotoSection.Popular.rawValue:
                        self.popularPhotos.append(decompressedImage)
                    case PhotoSection.Upcoming.rawValue:
                        self.upcomingPhotos.append(decompressedImage)
                    case PhotoSection.Editors.rawValue:
                        self.editorsPhotos.append(decompressedImage)
                    default:
                        break
                    }
                    self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: item, inSection: section)])
                    item += 1
                })
            }
        }
        
        PXRequest(forPhotoFeature: .Popular, resultsPerPage: 20, completion: block)
        PXRequest(forPhotoFeature: .Editors, resultsPerPage: 20, completion: block)
        PXRequest(forPhotoFeature: .Upcoming, resultsPerPage: 20, completion: block)
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return ViewController.numberOfSections
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewController.cellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        var array = [UIImage]()
        switch indexPath.section {
        case PhotoSection.Popular.rawValue:
            array = popularPhotos
        case PhotoSection.Editors.rawValue:
            array = editorsPhotos
        case PhotoSection.Upcoming.rawValue:
            array = upcomingPhotos
        default:
            break
        }
        
        guard indexPath.row < array.count else { return cell }
        cell.image = array[indexPath.item]
        return cell 
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewController.headerIdentifier, forIndexPath: indexPath) as! CollectionViewHeaderView
        
        switch indexPath.section {
        case PhotoSection.Popular.rawValue:
            headerView.text = "Popular"
        case PhotoSection.Editors.rawValue:
            headerView.text = "Editor's Choice"
        case PhotoSection.Upcoming.rawValue:
            headerView.text = "Upcoming"
        default:
            break
        }
        
        return headerView 
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView.collectionViewLayout == stackLayout {
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
            
            flowLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(flowLayout, animated: true)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: [.CenteredHorizontally, .CenteredVertically], animated: true)
            
            //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(goBack))
            navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(goBack)), animated: true)
            
        } else if collectionView.collectionViewLayout == flowLayout {
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
            
            coverFlowLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(coverFlowLayout, animated: true)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: [.CenteredHorizontally, .CenteredVertically], animated: true)
        } else {
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
    }
}

// MARK: Target - Action Methods

extension ViewController {
    
    @objc private func goBack() {
        if collectionView.collectionViewLayout == coverFlowLayout {
            flowLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(flowLayout, animated: true)
            
        } else if collectionView.collectionViewLayout == flowLayout {
            stackLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(stackLayout, animated: true)
            
            navigationItem.setLeftBarButtonItem(nil, animated: true)
        }
    }
    
    @objc private func handlePinch(recognizer: UIPinchGestureRecognizer) {
        guard collectionView.collectionViewLayout == stackLayout else { return }
        
        if recognizer.state == .Began {
            let initialPinchPoint: CGPoint = recognizer.locationInView(collectionView)
            if let pinchedCellPath = collectionView.indexPathForItemAtPoint(initialPinchPoint) {
                stackLayout.pinchedStackIndex = pinchedCellPath.section 
            }
        } else if recognizer.state == .Changed {
            stackLayout.pinchedStackScale = recognizer.scale
            stackLayout.pinchedStackCenter = recognizer.locationInView(collectionView)
        } else {
            guard stackLayout.pinchedStackIndex >= 0 else { return }
            
            if stackLayout.pinchedStackScale > 2.5 {
                collectionView.setCollectionViewLayout(flowLayout, animated: true)
                let barButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(goBack))
                navigationItem.setLeftBarButtonItem(barButtonItem, animated: true)
            } else {
                // collapse items back into stack 
                var leftoverViews = [UIView]()
                for subview in collectionView.subviews {
                    // Find all the supplementary views 
                    if subview is CollectionViewHeaderView {
                        leftoverViews.append(subview)
                    }
                }
                
                stackLayout.collapsing = true
                collectionView.performBatchUpdates({
                    self.stackLayout.pinchedStackIndex = -1
                    self.stackLayout.pinchedStackScale = 1.0
                    }, completion: { finished in
                        self.stackLayout.collapsing = false
                        // remove them from the view hierarchy
                        for subview in leftoverViews {
                            subview.removeFromSuperview()
                        }
                })
            }
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if collectionViewLayout == coverFlowLayout {
            var margin: CGFloat = 0.0
            
            if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
                margin = 130.0
            } else {
                margin = 280.0
            }
            var insets = UIEdgeInsetsZero
            
            if section == 0 { insets.left = margin }
            else if section == collectionView.numberOfSections() - 1 {
                insets.right = margin
            }
            
            return insets
            
        } else if collectionViewLayout == flowLayout {
            return flowLayout.sectionInset
        }
        
        // Should never happen
        return UIEdgeInsetsZero
    }
}


