//
//  CardViewController.swift
//  PRES
//
//  Created by Nikita on 23/11/2019.
//  Copyright © 2019 Radon Code. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    let contentView = UIView()
    let closeButton = UIButton()
    let contentLabel = UILabel()
    let swipeThreshold: CGFloat = 200
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
        self.setupUI()
    }
    
    // Progtammatically setting up the VC UI
    private func setupUI() {
        contentView.backgroundColor = UIColor.green
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        closeButton.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        contentLabel.text = "Your content here"
        contentLabel.font = UIFont.boldSystemFont(ofSize: 20)
        contentLabel.textColor = .white
        contentLabel.backgroundColor = .black
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let height: CGFloat = 500
        let xPosition: CGFloat = 0
        let width: CGFloat = view.frame.width
        let yPosition: CGFloat = view.frame.height - height
        
        contentView.frame = CGRect(
            x: xPosition,
            y: yPosition,
            width: width,
            height: height
        )
        
        view.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(contentLabel)
        contentView.addConstraints([
            NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .topMargin, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: closeButton, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        //Round the .topLeft and .topRight corners of the contentView
        contentView.layer.roundCorners([.topLeft, .topRight], radius: 20)
        contentView.layer.masksToBounds = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(recognizer:)))
        panGestureRecognizer.cancelsTouchesInView = false
        contentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    // This will dismiss the VC using the 'close' button
    @objc func closeAction (_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // This will dismiss the VC using the UIPanGestureRecognizer if the yTranslation is bigger than the swipeThreshold value.
    // If yTranslation is less than the swipeThreshold value, VC will bounce back to its original height
    @objc
    func handleDismiss (recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            viewTranslation = recognizer.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                guard self.viewTranslation.y > 0 else {return}
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < swipeThreshold {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

// Extension to round only select corners of a CALayer, in our case .topLeft and .topRight
extension CALayer {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let roundingSize = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: roundingSize)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.mask = mask
    }
}
