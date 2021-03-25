//
//  ViewController.swift
//  ShiningAnimation
//
//  Created by Bao Nguyen on 25/03/2021.
//  Copyright © 2021 Bao Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.startShiningAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLoad()
        if let gradientLayer = contentView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.contentView.bounds
        }
    }


}

