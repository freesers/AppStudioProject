//
//  DetailImageViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 24/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Viewcontroller to inspect chore image.
//  Users can zoom and pan around the image
//

import UIKit


class DetailImageViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Variables
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var image: UIImage?
    var imageTitle: String?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup scrollview
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6
        scrollView.delegate = self
        scrollView.contentMode = .scaleAspectFit
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        imageView.isUserInteractionEnabled = true
        
        // set image and title
        imageView.image = self.image!
        navigationBar.title = self.imageTitle!
    }
    
    /// set scrolview to imageview
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
