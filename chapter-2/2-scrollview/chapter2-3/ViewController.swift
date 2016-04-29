//
//  ViewController.swift
//  chapter2-3
//
//  Created by Hans Yelek on 4/25/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "5.jpg") else { return }
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = image.size
        scrollView.contentInset = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
        
        scrollView.addSubview(imageView)
        self.view.addSubview(scrollView)
    }
}

