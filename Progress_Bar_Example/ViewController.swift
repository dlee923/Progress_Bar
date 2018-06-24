//
//  ViewController.swift
//  Progress_Bar_Example
//
//  Created by Daniel Lee on 6/24/18.
//  Copyright © 2018 DLEE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .yellow
        
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -(CGFloat.pi / 2), endAngle: 2 * CGFloat.pi, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.purple.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        self.view.layer.addSublayer(shapeLayer)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        print("add stroke")
        
        animate_layer(keyPath: "strokeEnd", toValue: 1, duration: 1, forKey: "animate_stroke")
        animate_layer(keyPath: "lineWidth", toValue: 15, duration: 0.75, forKey: "animate_width")
    }
    
    func animate_layer(keyPath: String, toValue: Double, duration: Double, forKey: String) {
        let basicAnimation = CABasicAnimation(keyPath: keyPath)
        basicAnimation.toValue = toValue
        basicAnimation.duration = duration
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: forKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

