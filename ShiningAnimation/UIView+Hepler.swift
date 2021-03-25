//
//  UIView+Hepler.swift
//  ShiningAnimation
//
//  Created by Bao Nguyen on 25/03/2021.
//  Copyright © 2021 Bao Nguyen. All rights reserved.
//

import UIKit.UIView

extension UIView {
    // Helper to snapshot a view
    var snapshot: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        
        let image = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return image
    }
    
    func startShiningAnimation() {
        // Take as snapshot of the button and render as a template
        let snapshot = self.snapshot?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: snapshot)
        // Add it image view and render close to white
        imageView.tintColor = UIColor(white: 1.0, alpha: 1.0)
        guard let image = imageView.snapshot  else { return }
        let width = image.size.width
        let height = image.size.height
        // Create CALayer and add light content to it
        let shineLayer = CALayer()
        shineLayer.contents = image.cgImage
        shineLayer.frame = bounds
        // create CAGradientLayer that will act as mask clear = not shown, opaque = rendered
        // Adjust gradient to increase width and angle of highlight
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.white.withAlphaComponent(0.6).cgColor,
                                UIColor.clear.cgColor,
                                UIColor.clear.cgColor,]
        gradientLayer.locations = [ 0.0, 0.4, 0.5, 0.4, 0.0]
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width * 2, height: height * 2)
        // Create CA animation that will move mask from outside bounds top-right to outside bottom-left
        let animation = CABasicAnimation(keyPath: "position")
        animation.byValue = width
        // How long it takes for glare to move across button
        animation.duration = 1.5
        // Repeat forever
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = CGPoint(x: width, y: 0)
        animation.toValue = CGPoint(x: -width, y: height + width)
        
        layer.addSublayer(shineLayer)
        shineLayer.mask = gradientLayer
        
        // Add animation
        gradientLayer.add(animation, forKey: "shining-animation")
    }
    
    func stopShiningAnimation() {
        // Search all sublayer masks for "shine" animation and remove
        layer.removeAllAnimations()
        layer.sublayers?.forEach {
            if ($0.mask?.animation(forKey: "shining-animation")) != nil {
                $0.mask?.removeAnimation(forKey: "shining-animation")
                $0.removeFromSuperlayer()
            }
        }
    }
}
