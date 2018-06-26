//
//  ViewController.swift
//  Progress_Bar_Example
//
//  Created by Daniel Lee on 6/24/18.
//  Copyright © 2018 DLEE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("download finished")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        print(percentage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .yellow
        
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -(CGFloat.pi / 2), endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.black.cgColor.copy(alpha: 0.5)
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        
        self.view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.purple.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        self.view.layer.addSublayer(shapeLayer)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    let urlString = "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg"
    
    fileprivate func animateProgressBar() {
        animate_layer(keyPath: "strokeEnd", toValue: 1, duration: 1, forKey: "animate_stroke", itemToAnimate: self.shapeLayer)
        animate_layer(keyPath: "lineWidth", toValue: 10, duration: 0.75, forKey: "animate_width", itemToAnimate: self.shapeLayer)
        animate_layer(keyPath: "lineWidth", toValue: 10, duration: 0.75, forKey: "animate_width", itemToAnimate: self.trackLayer)
    }
    
    func animate_layer(keyPath: String, toValue: Double, duration: Double, forKey: String, itemToAnimate: CAShapeLayer) {
        let basicAnimation = CABasicAnimation(keyPath: keyPath)
        basicAnimation.toValue = toValue
        basicAnimation.duration = duration
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        itemToAnimate.add(basicAnimation, forKey: forKey)
    }
    
    private func downloadFile() {
        let config = URLSessionConfiguration.default
        let operation = OperationQueue()
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: operation)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    @objc private func handleTap() {
        print("download file")
        
        downloadFile()
        
        animateProgressBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

