//
//  ViewController.swift
//  Progress_Bar_Example
//
//  Created by Daniel Lee on 6/24/18.
//  Copyright © 2018 DLEE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    var shapeLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var pulseLayer: CAShapeLayer!
    
    let progressPct: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textColor = .purple
        return label
    }()
    let progressStatus: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .purple
        return label
    }()
    let progressContainer = UILabel()
    let containerDimension: CGFloat = 100
    let progressStatusPct: CGFloat = 0.8
    let trackWidthStart: CGFloat = 8
    let trackWidthEnd: CGFloat = 12
    
    let urlString = "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .yellow
        
        pulseLayer = createCircularLayer(fillColor: UIColor.purple.withAlphaComponent(0.85), strokeColor: .clear)
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.toValue = 1.2
        pulseAnimation.duration = 0.8
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        pulseLayer.add(pulseAnimation, forKey: "pulse")
        self.view.layer.addSublayer(pulseLayer!)
        
        trackLayer = createCircularLayer(fillColor: .yellow, strokeColor: .lightGray)
        self.view.layer.addSublayer(trackLayer!)
        
        shapeLayer = createCircularLayer(fillColor: .clear, strokeColor: .purple)
        shapeLayer.strokeEnd = 0
        self.view.layer.addSublayer(shapeLayer!)
        
        add_downloading_labels()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func createCircularLayer(fillColor: UIColor, strokeColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 75, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.transform = CATransform3DMakeRotation(-(CGFloat.pi / 2), 0, 0, 1)
        layer.strokeColor = strokeColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.lineWidth = trackWidthStart
        layer.fillColor = fillColor.cgColor
        layer.position = self.view.center
        return layer
    }
    
    fileprivate func add_downloading_labels() {
        progressContainer.frame = CGRect(x: 0, y: 0, width: containerDimension, height: containerDimension)
        progressPct.frame = CGRect(x: 0, y: 0, width: containerDimension, height: containerDimension * progressStatusPct)
        progressStatus.frame = CGRect(x: 0, y: containerDimension * progressStatusPct, width: containerDimension, height: containerDimension * (1-progressStatusPct))
        progressContainer.addSubview(progressPct)
        progressContainer.addSubview(progressStatus)
        self.view.addSubview(progressContainer)
        progressContainer.center = self.view.center
        
        progressPct.textAlignment = .center
        progressStatus.textAlignment = .center
        
        progressPct.text = "0%"
        progressStatus.text = "standby..."
    }
    
    /*
    fileprivate func animateProgressBar() {
        animate_layer(keyPath: "strokeEnd", toValue: 1, duration: 1, forKey: "animate_stroke", itemToAnimate: self.shapeLayer)
        animate_layer(keyPath: "lineWidth", toValue: 15, duration: 0.75, forKey: "animate_width", itemToAnimate: self.shapeLayer)
        animate_layer(keyPath: "lineWidth", toValue: 15, duration: 0.75, forKey: "animate_width", itemToAnimate: self.trackLayer)
    }
    
    func animate_layer(keyPath: String, toValue: Double, duration: Double, forKey: String, itemToAnimate: CAShapeLayer) {
        let basicAnimation = CABasicAnimation(keyPath: keyPath)
        basicAnimation.toValue = toValue
        basicAnimation.duration = duration
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        itemToAnimate.add(basicAnimation, forKey: forKey)
    }
    */
 
    private func downloadFile() {
        self.shapeLayer.strokeEnd = 0
        progressPct.text = "0%"
        progressStatus.text = "downloading..."
        
        let config = URLSessionConfiguration.default
        let operation = OperationQueue()
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: operation)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("download finished")
        DispatchQueue.main.async {
            self.progressStatus.text = "finished"
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        let rounded_pct = Int(percentage * 100)
        
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = percentage
            self.shapeLayer.lineWidth = percentage * self.trackWidthEnd < self.trackWidthStart ? self.trackWidthStart : percentage * self.trackWidthEnd
            self.trackLayer.lineWidth = percentage * self.trackWidthEnd < self.trackWidthStart ? self.trackWidthStart : percentage * self.trackWidthEnd
            self.progressPct.text = "\(rounded_pct)%"
        }
        
        print(percentage)
    }
    
    @objc private func handleTap() {
        print("download file")
        
        downloadFile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

