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
    
    override class func layoutAttributesClass() -> AnyClass {
        return CollectionViewLayoutAttributes.self
    }
    
    override func collectionViewContentSize() -> CGSize {
        return contentSize
    }
    
    override func prepareLayout() {
        prepareStacksLayout()
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
        
        return attributes
    }
}
