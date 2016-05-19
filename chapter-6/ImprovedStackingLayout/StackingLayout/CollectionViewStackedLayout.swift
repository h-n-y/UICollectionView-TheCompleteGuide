//
//  CollectionViewStackedLayout.swift
//  StackingLayout
//
//  Created by Hans Yelek on 5/14/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

private let STACK_FOOTER_GAP: CGFloat = 8.0
private let STACK_FOOTER_HEIGHT: CGFloat = 25.0
private let ITEM_SIZE: CGFloat = 170.0
private let VISIBLE_ITEMS_PER_STACK = 3

private let MINIMUM_INTERSTACK_SPACING_IPAD: CGFloat = 50.0
private let STACKS_TOP_MARGIN: CGFloat = 20.0
private let STACKS_BOTTOM_MARGIN: CGFloat = 20.0
private let STACKS_LEFT_MARGIN: CGFloat = 20.0
private let STACKS_RIGHT_MARGIN: CGFloat = 20.0
private let STACK_WIDTH: CGFloat = 180.0
private let STACK_HEIGHT: CGFloat = 180.0

private let MIN_PINCH_SCALE: CGFloat = 1.0
private let MAX_PINCH_SCALE: CGFloat = 4.0

private let FADE_PROGRESS: CGFloat = 0.75

class CollectionViewStackedLayout: UICollectionViewLayout {
    
    
    
    private var numberOfStacks = 0
    private var numberOfStacksAcross = 0
    private var numberOfStackRows = 0
    
    private var stackSize = CGSize(width: STACK_WIDTH, height: STACK_HEIGHT)
    private var pageSize = CGSizeZero
    private var contentSize = CGSizeZero
    
    private var stackInsets = UIEdgeInsets(top: STACKS_TOP_MARGIN, left: STACKS_LEFT_MARGIN, bottom: STACKS_BOTTOM_MARGIN, right: STACKS_RIGHT_MARGIN)
    
    private var minimumInterStackSpacing: CGFloat = MINIMUM_INTERSTACK_SPACING_IPAD
    private var minimumLineSpacing: CGFloat = MINIMUM_INTERSTACK_SPACING_IPAD
    
    private var stackFrames = [CGRect]()
    private var itemFrames  = [CGRect]()
    
    private var gridLayout: CollectionViewFlowLayout? = nil
    
    var pinchedStackIndex: Int = -1 {
        didSet {
            let wasPinching = isPinching
            isPinching = pinchedStackIndex >= 0
            if isPinching != wasPinching {
                if isPinching {
                    gridLayout = CollectionViewFlowLayout()
                } else {
                    gridLayout = nil
                }
            }
            invalidateLayout()
        }
    }
    var pinchedStackScale: CGFloat = 1.0 {
        didSet {
            invalidateLayout()
        }
    }
    var pinchedStackCenter: CGPoint = CGPointZero {
        didSet {
            invalidateLayout()
        }
    }
    var collapsing: Bool = false
    private var isPinching: Bool = false
    
    
    override class func layoutAttributesClass() -> AnyClass {
        return CollectionViewLayoutAttributes.self
    }
    
    override func collectionViewContentSize() -> CGSize {
        return contentSize
    }
    
    override func prepareLayout() {
        prepareStacksLayout()
        if isPinching {
            prepareItemsLayout()
        }
    }

    private func prepareStacksLayout() {
        
        numberOfStacks = collectionView!.numberOfSections()
        pageSize = collectionView!.bounds.size 
        
        let availableWidth = pageSize.width - ( stackInsets.left + stackInsets.right )
        
        numberOfStacksAcross = Int(floor(( availableWidth + minimumInterStackSpacing ) / ( stackSize.width + minimumInterStackSpacing )))
        
        let spacing = floor(( availableWidth - (CGFloat(numberOfStacksAcross) * stackSize.width) ) / CGFloat(numberOfStacksAcross - 1))
        numberOfStackRows = Int(ceil(CGFloat(numberOfStacks) / CGFloat(numberOfStacksAcross)))
        
        var stackColumn = 0
        var stackRow = 0
        var left = stackInsets.left
        var top = stackInsets.top
        
        for _ in 0..<numberOfStacks {
            
            let stackFrame = CGRect(origin: CGPoint(x: left, y: top), size: stackSize)
            stackFrames.append(stackFrame)
            
            left += stackSize.width + spacing
            stackColumn += 1
            
            if stackColumn >= numberOfStacksAcross {
                
                left = stackInsets.left
                top += stackSize.height + STACK_FOOTER_GAP + STACK_FOOTER_HEIGHT + minimumLineSpacing
                stackColumn = 0
                stackRow += 1
            }
        }
        
        let contentWidth = pageSize.width
        let contentHeight = max(pageSize.height, stackInsets.top + (CGFloat(numberOfStackRows) * (stackSize.height + CGFloat(STACK_FOOTER_GAP + STACK_FOOTER_HEIGHT))) + (CGFloat(numberOfStackRows - 1) * minimumLineSpacing) + stackInsets.bottom)
        contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    private func prepareItemsLayout() {
        guard let collectionView = self.collectionView else { return }
        guard let grid = gridLayout else { return }
        
        
        let numberOfItems = collectionView.numberOfItemsInSection(pinchedStackIndex)
        let availableWidth: CGFloat = pageSize.width - ( grid.sectionInset.left + grid.sectionInset.right )
        let numberOfItemsAcross = floor((availableWidth + grid.minimumInteritemSpacing) / (grid.itemSize.width + grid.minimumInteritemSpacing))
        let spacing: CGFloat = floor((availableWidth - (numberOfItemsAcross * grid.itemSize.width)) / CGFloat(numberOfItemsAcross - 1))
        
        var column = 0
        var row = 0
        var left: CGFloat = grid.sectionInset.left
        var top: CGFloat = grid.sectionInset.top
        for _ in 0..<numberOfItems {
            let itemFrame = CGRect(origin: CGPoint(x: left, y: top + collectionView.contentOffset.y), size: grid.itemSize)
            itemFrames.append(itemFrame)
            
            left += grid.itemSize.width + spacing
            column += 1
            
            if column >= Int(numberOfItemsAcross) {
                left = grid.sectionInset.left
                top += grid.itemSize.height + grid.minimumLineSpacing
                column = 0
                row += 1
            }
            
            if top >= pageSize.height {
                break
            }
        }
        
        let numberOfItemRows = ceil(CGFloat(itemFrames.count) / CGFloat(numberOfItemsAcross))
        
        let itemContentSize = CGSize(width: pageSize.width, height: grid.sectionInset.top + (CGFloat(numberOfItemRows) * grid.itemSize.height) + ((numberOfItemRows - 1) * grid.minimumLineSpacing) + grid.sectionInset.bottom)
        let stackContentSize = contentSize
        contentSize = CGSize(width: max(itemContentSize.width, stackContentSize.width), height: max(itemContentSize.height, stackContentSize.height))
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let stackFrame = stackFrames[indexPath.section]
        
        let attributes = CollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.size = CGSize(width: ITEM_SIZE, height: ITEM_SIZE)
        attributes.center = CGPoint(x: CGRectGetMidX(stackFrame), y: CGRectGetMidY(stackFrame))
        
        var angle: CGFloat = 0
        
        if indexPath.item == 1 {
            angle = 5.0
        } else if indexPath.item == 2 {
            angle = -5.0
        }
        
        attributes.transform3D = CATransform3DMakeRotation(angle * CGFloat(M_PI / 180.0), 0, 0, 1)
        attributes.alpha = indexPath.item >= VISIBLE_ITEMS_PER_STACK ? 0 : 1
        attributes.zIndex = indexPath.item >= VISIBLE_ITEMS_PER_STACK ? 0: VISIBLE_ITEMS_PER_STACK - indexPath.item
        attributes.shadowOpacity = indexPath.item >= VISIBLE_ITEMS_PER_STACK ? 0 : 0.5
        attributes.hidden = indexPath.item >= VISIBLE_ITEMS_PER_STACK
        
        if isPinching {
            // convert pinch scale to progress: 0 to 1 
            let progress: CGFloat = min(max(pinchedStackScale - MIN_PINCH_SCALE / (MAX_PINCH_SCALE - MIN_PINCH_SCALE), 0), 1.0)
            
            if indexPath.section == pinchedStackIndex {
                let itemCount = itemFrames.count
                if indexPath.item < itemCount {
                    let itemFrame: CGRect = itemFrames[indexPath.item]
                    let newX: CGFloat = attributes.center.x * ( 1.0 - progress ) + CGRectGetMidX(itemFrame) * progress
                    let newY: CGFloat = attributes.center.y * ( 1.0 - progress ) + CGRectGetMidY(itemFrame) * progress
                    attributes.center = CGPoint(x: newX, y: newY)
                    angle *= ( 1.0 - progress )
                    attributes.transform3D = CATransform3DMakeRotation(angle * CGFloat(M_PI / 180.0), 0, 0, 1)
                    attributes.zIndex = ( itemCount + VISIBLE_ITEMS_PER_STACK) - indexPath.item
                    attributes.alpha = 1.0
                    attributes.hidden = false
                    if indexPath.item >= VISIBLE_ITEMS_PER_STACK {
                        attributes.shadowOpacity = 0.5 * progress
                    }
                }
            } else {
                if !attributes.hidden {
                    if progress >= FADE_PROGRESS {
                        attributes.alpha = 0.0
                    } else {
                        attributes.alpha = 1.0 - ( progress / FADE_PROGRESS )
                    }
                }
            }
        }
        
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        
        for stack in 0..<numberOfStacks {
            var stackFrame = stackFrames[stack]
            stackFrame.size.height += ( STACK_FOOTER_GAP + STACK_FOOTER_HEIGHT )
            
            guard CGRectIntersectsRect(stackFrame, rect) else { return nil }
            guard let itemCount = collectionView?.numberOfItemsInSection(stack) else { return nil }
            
            for item in 0..<itemCount {
                let indexPath = NSIndexPath(forItem: item, inSection: stack)
                if let attribute = layoutAttributesForItemAtIndexPath(indexPath) {
                    attributes.append(attribute)
                }
                
                // add small label as footer 
                if let supplementaryAttributes = layoutAttributesForSupplementaryViewOfKind(CollectionViewHeaderView.kind, atIndexPath: NSIndexPath(forItem: 0, inSection: stack)) {
                    attributes.append(supplementaryAttributes)
                }
            }
        }
        
        return attributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == CollectionViewHeaderView.kind else { return nil }
        
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        attributes.size = CGSize(width: STACK_WIDTH, height: STACK_FOOTER_HEIGHT)
        
        let stackFrame: CGRect = stackFrames[indexPath.section]
        attributes.center = CGPoint(x: CGRectGetMidX(stackFrame), y: CGRectGetMaxY(stackFrame) + STACK_FOOTER_GAP + ( STACK_FOOTER_HEIGHT / 2.0 ))
        
        if isPinching {
            // convert pinch scale to progress: 0 to 1
            let progress: CGFloat = min(max((pinchedStackScale - MIN_PINCH_SCALE) / (MAX_PINCH_SCALE - MIN_PINCH_SCALE) , 0.0), 1.0)
            
            if progress >= FADE_PROGRESS {
                attributes.alpha = 0.0
            } else {
                attributes.alpha = 1.0 - (progress/FADE_PROGRESS)
            }
        }
        
        return attributes
    }
}
