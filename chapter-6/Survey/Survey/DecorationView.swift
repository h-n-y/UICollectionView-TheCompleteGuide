//
//  DecorationView.swift
//  Survey
//
//  Created by Hans Yelek on 4/30/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class DecorationView: UICollectionReusableView {
    
    // MARK: Instance
    
    private let binderImageView: UIImageView
    
    override init(frame: CGRect) {
        binderImageView = DecorationView.newBinderImageView()
        
        super.init(frame: frame)
        
        addImageViewToHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        binderImageView = DecorationView.newBinderImageView()
        
        super.init(coder: aDecoder)
        
        addImageViewToHierarchy()
    }
    
    private func addImageViewToHierarchy() {
        addSubview(binderImageView)
        binderImageView.constrainLeftEdgeToContainerWithInset(10)
        binderImageView.constrainTopEdgeToContainer()
    }
    
    // MARK: Class
    
    private class func newBinderImageView() -> UIImageView {
        let image = UIImage(named: "binder")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .Left
        
        return imageView
    }
}
