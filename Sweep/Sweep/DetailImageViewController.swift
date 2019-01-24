//
//  DetailImageViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 24/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var image: UIImage?
    var imageTitle: String?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6
        scrollView.delegate = self
        scrollView.contentMode = .scaleAspectFit
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        imageView.isUserInteractionEnabled = true
        
        imageView.image = self.image!
        navigationBar.title = self.imageTitle!
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
