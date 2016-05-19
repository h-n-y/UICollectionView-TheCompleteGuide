import UIKit

class ViewController: UIViewController {
    
    private static let CELL_IDENTIFIER = "Cell Identifier"

    private let photoModelArray: [PhotoModel]
    
    private let collectionView: UICollectionView
    private let coverFlowCollectionViewLayout = CoverFlowFlowLayout()
    private let boringCollectionViewLayout = UICollectionViewFlowLayout()
    
    private func setupBoringCollectionViewLayout() {
        boringCollectionViewLayout.itemSize = CGSize(width: 140, height: 140)
        boringCollectionViewLayout.minimumLineSpacing = 10.0
        boringCollectionViewLayout.minimumInteritemSpacing = 10.0
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: ViewController.CELL_IDENTIFIER)
        collectionView.allowsSelection = false
        collectionView.indicatorStyle = .White
        collectionView.backgroundColor = UIColor.blackColor()
        view.addSubview(collectionView)
        collectionView.constrainEdgesToContainer()
    }
    
    private func setupLayoutChangeSegmentedControl() {
        let layoutChangeSegmentedControl = UISegmentedControl(items: ["Boring", "Cover Flow"])
        layoutChangeSegmentedControl.selectedSegmentIndex = 0
        layoutChangeSegmentedControl.addTarget(self, action: #selector(layoutChangeSegmentedControlDidChangeValue(_:)), forControlEvents: .ValueChanged)
        
        navigationItem.titleView = layoutChangeSegmentedControl
    }
    
    private func setupTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        collectionView.addGestureRecognizer(tapRecognizer)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: boringCollectionViewLayout)
        photoModelArray = ViewController.newPhotoModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupBoringCollectionViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: boringCollectionViewLayout)
        photoModelArray = ViewController.newPhotoModel()
        super.init(coder: aDecoder)
        setupBoringCollectionViewLayout()
    }
    
    private func setupModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupLayoutChangeSegmentedControl()
        setupTapGestureRecognizer()
    }
    
    private func photoModelForIndexPath(indexPath: NSIndexPath) -> PhotoModel? {
        guard indexPath.item < photoModelArray.count else { return nil }
        
        return photoModelArray[indexPath.item]
    }

    // MARK: Target - Action Methods
    
    @objc private func layoutChangeSegmentedControlDidChangeValue(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            collectionView.setCollectionViewLayout(boringCollectionViewLayout, animated: false)
        } else {
            collectionView.setCollectionViewLayout(coverFlowCollectionViewLayout, animated: false)
        }
        
        // Invalidate the new layout
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModelArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewController.CELL_IDENTIFIER, forIndexPath: indexPath) as! CollectionViewCell
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    /// Helper method for `collectionView(_:, cellForItemAtIndexPath:) -> UICollectionViewCell`
    private func configureCell(cell: CollectionViewCell, forIndexPath indexPath: NSIndexPath) {
        if let image: UIImage = photoModelForIndexPath(indexPath)?.image {
            print("IMAGE: \(image)")
            cell.image = image
            //cell.setImageViewFrame(animate: false)
        }
    }
}

// MARK: - UICollectionViewDelegate 

extension ViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if collectionViewLayout == boringCollectionViewLayout {
            // A basic flow layout that will accomodate three columns in portrait
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
        
        // Note: `interfaceOrientation` is deprecated in iOS 8
        // Should probably be using size classes instead of being concerned with device
        // orientation or type.
        if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
            // Portrait is the same in either orientation
            return UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 70)
        } else {    // Landscape
            // We need to het the height of the main screen to see if we're running on a 4'' screen. 
            // If so, we need extra side padding
            if UIScreen.mainScreen().bounds.size.height > 480 {
                return UIEdgeInsets(top: 0, left: 190, bottom: 0, right: 190)
            } else {
                return UIEdgeInsets(top: 0, left: 150, bottom: 0, right: 150)
            }
        }
    }
}

// MARK: - Model Creation

extension ViewController {
    
    private class func newPhotoModel() -> [PhotoModel] {
        let model: [PhotoModel] = [
            
            PhotoModel.photoModelWithName("Purple Flower", image: UIImage(named: "0.jpg")),
            PhotoModel.photoModelWithName("WWDC Hypertable", image: UIImage(named: "1.jpg")),
            PhotoModel.photoModelWithName("Purple Flower II", image: UIImage(named: "2.jpg")),
            PhotoModel.photoModelWithName("Castle", image: UIImage(named: "3.jpg")),
            PhotoModel.photoModelWithName("Skyward Look", image: UIImage(named: "4.jpg")),
            PhotoModel.photoModelWithName("Kakabeka Falls", image: UIImage(named: "5.jpg")),
            PhotoModel.photoModelWithName("Puppy", image: UIImage(named: "6.jpg")),
            PhotoModel.photoModelWithName("Thunder Bay Sunset", image: UIImage(named: "7.jpg")),
            PhotoModel.photoModelWithName("Sunflower I", image: UIImage(named: "8.jpg")),
            PhotoModel.photoModelWithName("Sunflower II", image: UIImage(named: "9.jpg")),
            PhotoModel.photoModelWithName("Sunflower I", image: UIImage(named: "10.jpg")),
            PhotoModel.photoModelWithName("Squirrel", image: UIImage(named: "11.jpg")),
            PhotoModel.photoModelWithName("Montréal Subway", image: UIImage(named: "12.jpg")),
            PhotoModel.photoModelWithName("Geometrically Intriguing Flower", image: UIImage(named: "13.jpg")),
            PhotoModel.photoModelWithName("Grand Lake", image: UIImage(named: "17.jpg")),
            PhotoModel.photoModelWithName("Spadina Subway Station", image: UIImage(named: "15.jpg")),
            PhotoModel.photoModelWithName("Staircase to Grey", image: UIImage(named: "14.jpg")),
            PhotoModel.photoModelWithName("Saint John River", image: UIImage(named: "16.jpg")),
            PhotoModel.photoModelWithName("Purple Bokeh Flower", image: UIImage(named: "18.jpg")),
            PhotoModel.photoModelWithName("Puppy II", image: UIImage(named: "19.jpg")),
            PhotoModel.photoModelWithName("Plant", image: UIImage(named: "21.jpg")),
            PhotoModel.photoModelWithName("Peggy's Cove I", image: UIImage(named: "21.jpg")),
            PhotoModel.photoModelWithName("Peggy's Cove II", image: UIImage(named: "22.jpg")),
            PhotoModel.photoModelWithName("Sneaky Cat", image: UIImage(named: "23.jpg")),
            PhotoModel.photoModelWithName("King Street West", image: UIImage(named: "24.jpg")),
            PhotoModel.photoModelWithName("TTC Streetcar", image: UIImage(named: "25.jpg")),
            PhotoModel.photoModelWithName("UofT at Night", image: UIImage(named: "26.jpg")),
            PhotoModel.photoModelWithName("Mushroom", image: UIImage(named: "27.jpg")),
            PhotoModel.photoModelWithName("Montréal Subway Selective Colour", image: UIImage(named: "28.jpg")),
            PhotoModel.photoModelWithName("On Air", image: UIImage(named: "29.jpg")),
            
            ]
        
        return model
    }
}

// MARK: - Target - Action Methods

extension ViewController {
    
    @objc private func handleTapGestureRecognizer(recognizer: UITapGestureRecognizer) {
        guard collectionView.collectionViewLayout == coverFlowCollectionViewLayout else { return }
        guard recognizer.state == .Ended else { return }
        
        let point = recognizer.locationInView(collectionView)
        guard let indexPath = collectionView.indexPathForItemAtPoint(point) else { return }
        
        let centered = coverFlowCollectionViewLayout.indexPathIsCentered(indexPath)
        if centered {
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                UIView.transitionWithView(cell,
                                          duration: 0.5,
                                          options: .TransitionFlipFromRight,
                                          animations: {
                                            cell.bounds = cell.bounds
                                        },
                                          completion: nil)
            }
        } else {
            var proposedOffset = CGPointZero
            if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
                proposedOffset.x = CGFloat(indexPath.item) * ( coverFlowCollectionViewLayout.itemSize.width + coverFlowCollectionViewLayout.minimumLineSpacing )
            } else {
                proposedOffset.x = CGFloat(indexPath.item - 1) * ( coverFlowCollectionViewLayout.itemSize.width + coverFlowCollectionViewLayout.minimumLineSpacing )
            }
            
            let contentOffset = coverFlowCollectionViewLayout.targetContentOffsetForProposedContentOffset(proposedOffset, withScrollingVelocity: CGPointZero)
            collectionView.setContentOffset(contentOffset, animated: true)
        }
    }
}
