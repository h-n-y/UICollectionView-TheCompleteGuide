//
//  ViewController.swift
//  CircleLayout
//
//  Created by Hans Yelek on 5/9/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static let CELL_IDENTIFIER = "Cell Identifier"
    
    var cellCount = 12
    
    let flowLayout      = CollectionViewFlowLayout()
    let circleLayout    = CollectionViewCircleLayout()
    let collectionView: UICollectionView
    
    //let layoutChangeSegmentedControl: UISegmentedControl
    

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: ViewController.CELL_IDENTIFIER)
        view.addSubview(collectionView)
        collectionView.constrainEdgesToContainer()
    }
    
    private func setupBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(deleteItem))
    }
    
    private func setupSegmentedControl() {
        
        let layoutChangeSegmentedControl = UISegmentedControl(items: ["Circle", "Flow"])
        layoutChangeSegmentedControl.selectedSegmentIndex = 0
        layoutChangeSegmentedControl.addTarget(self, action: #selector(layoutChangeSegmentedControlDidChangeValue(_:)), forControlEvents: .ValueChanged)
        navigationItem.titleView = layoutChangeSegmentedControl
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: circleLayout)
        
        super.init(coder: aDecoder)
        
        setupCollectionView()
        setupBarButtonItems()
        setupSegmentedControl()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: circleLayout)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupCollectionView()
        setupBarButtonItems()
        setupSegmentedControl()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewController.CELL_IDENTIFIER, forIndexPath: indexPath) as! CollectionViewCell
        cell.labelString = "\(indexPath.row)"
        return cell 
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - Target - Action Methods

extension ViewController {
    
    @objc private func addItem() {
        
        cellCount += 1
        
        if collectionView.collectionViewLayout == flowLayout {
            flowLayout.addItem()
        } else if collectionView.collectionViewLayout == circleLayout {
            circleLayout.addItem()
        }
    }
    
    @objc private func deleteItem() {
        
        guard cellCount > 1 else { return }
        cellCount -= 1
        
        if collectionView.collectionViewLayout == flowLayout {
            flowLayout.deleteItem()
        } else if collectionView.collectionViewLayout == circleLayout {
            circleLayout.deleteItem()
        }
    }
    
    @objc private func layoutChangeSegmentedControlDidChangeValue(sender: UISegmentedControl) {
        
        if collectionView.collectionViewLayout == circleLayout {
            
            flowLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(flowLayout, animated: true)
            
        } else {
            
            circleLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(circleLayout, animated: true)
        }
    }
}

extension ViewController: CollectionViewDelegateCircleLayout {
    
    func rotationAngleForSupplementaryViewInCircleLayout(layout: CollectionViewCircleLayout) -> CGFloat {
        var timeRatio: CGFloat = 0.0
        
        let date = NSDate()
        let component = NSCalendar.currentCalendar().component(.Minute, fromDate: date)
        timeRatio = CGFloat(component) / 60.0
        
        return CGFloat(2 * M_PI) * timeRatio
    }
}