import UIKit

class ViewController: UIViewController {
    
    private static let CELL_IDENTIFIER = "Cell Identifier"
    
    private let photoModelArray = ViewController.newPhotoModel()
    //private let aspectChangeSegmentedControl = UISegmentedControl()
    
    private let photoCollectionViewLayout = CollectionViewFlowLayout()
    private let photoCollectionView: UICollectionView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        photoCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: photoCollectionViewLayout)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        photoCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: photoCollectionViewLayout)
        
        super.init(coder: aDecoder)
    }
    
    private func setupCollectionView() {
        photoCollectionView.frame = CGRectZero
        photoCollectionView.collectionViewLayout = photoCollectionViewLayout
        photoCollectionView.dataSource = self
        //photoCollectionView.delegate = self
        photoCollectionView.allowsSelection = false
        photoCollectionView.indicatorStyle = .White
        
        photoCollectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: ViewController.CELL_IDENTIFIER)
        
        view.addSubview(photoCollectionView)
        photoCollectionView.constrainEdgesToContainer()
    }
    
    private func setupSegmentedControl() {
        let aspectChangeSegmentedControl = UISegmentedControl(items: ["Square", "Aspect Fit"])
        aspectChangeSegmentedControl.selectedSegmentIndex = 0
        aspectChangeSegmentedControl.addTarget(self, action: #selector(aspectChangeSegmentedControlDidChangeValue(_:)), forControlEvents: .ValueChanged)
        
        navigationItem.titleView = aspectChangeSegmentedControl
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupCollectionView()
        setupSegmentedControl()
    }

    @objc private func aspectChangeSegmentedControlDidChangeValue(sender: UISegmentedControl) {
        // We need to explicitly tell the collection view layout that we want
        // the change animated 
        UIView.animateWithDuration(0.5, animations: {
            if self.photoCollectionViewLayout.layoutMode == .AspectFill {
                self.photoCollectionViewLayout.layoutMode = .AspectFit
            } else {
                self.photoCollectionViewLayout.layoutMode = .AspectFill 
            }
        })
    }
    
    private func photoModelForIndexPath(indexPath: NSIndexPath) -> PhotoModel? {
        guard indexPath.item < photoModelArray.count else { return nil }
        
        return photoModelArray[indexPath.item]
    }
}

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
            cell.image = image
            cell.setImageViewFrame(animate: false)
        }
    }
}

