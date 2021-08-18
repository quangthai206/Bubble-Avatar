//
//  ViewController.swift
//  BubbleAvatar
//
//  Created by quangthai206 on 17/08/2021.
//

import UIKit

class ViewController: UIViewController {
    
    var customPath: UIBezierPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /// Convert degree to radian
    ///
    /// - Parameters:
    ///   - number: in degree
    /// - Returns: number in radian
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180
    }
    
    func setupUI() {
        let width: CGFloat = 250
        let radius: CGFloat = width / 2
        
        // Distance between circle border and the point outside the circle
        let d: CGFloat = radius * 0.3
        
        let angle1: CGFloat = 145
        let angle2: CGFloat = 125
        
        customPath = UIBezierPath()
        customPath?.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: deg2rad(angle1), endAngle:  deg2rad(angle2), clockwise: true)
        
        // MATH FORMULA
        // https://www.freemathhelp.com/forum/threads/need-help-finding-3rd-set-of-coordinates-to-a-right-triangle.82575/
        
        let xB = radius - radius * sin(deg2rad(angle1 - 90))
        let yB = radius + radius * cos(deg2rad(angle1 - 90))
        
        let xC = radius - radius * sin(deg2rad(angle2 - 90))
        let yC = radius + radius * cos(deg2rad(angle2 - 90))
        
        let xE = (xB + xC) / 2
        let yE = (yB + yC) / 2
        
        let AD = radius + d
        
        let BC = (pow(xC - xB, 2) + pow(yC - yB, 2)).squareRoot()
        let BE = BC / 2
        let AE = (pow(radius, 2) - pow(BE, 2)).squareRoot()
        
        let DE = AD - AE
        
        let xD = xE + ( DE * (yB - yE) / BE )
        let yD = yE + ( DE * (xE - xB) / BE )
        
        customPath?.addLine(to: CGPoint(x: xD, y: yD))
        customPath?.close()
        
        let customShape = CAShapeLayer()
        customShape.path = customPath?.cgPath
        customShape.frame = CGRect(x: 0, y: 0, width: width, height: width)
        
        let imageView = UIImageView(image: UIImage(named: "avatar"))
        imageView.frame.size = CGSize(width: width, height: width)
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFill
        
        // Set mask to image
        imageView.layer.mask = customShape
        
        // Add tap gesture to image
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        view.addSubview(imageView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let p = sender.location(in: sender.view)
        
        if let customPath = customPath, customPath.contains(p) {
            print("Inside")
        } else {
            print("Outside")
        }
    }
}

