//
//  TAGProgressViewController.swift
//  ProgressIndicator
//
//  Created by Niks on 15/12/15.
//  Copyright © 2015 TheAppGuruz. All rights reserved.
//

import UIKit

class TAGProgressViewController: UIViewController
{
    var intNumberOfCircles: Int = 10
    var circleRadius: CGFloat = 10
    var spaceBetweenCircles: CGFloat = 5
    var duration = 0.8
    var delay = 0.2
    
    var vwCircleParent = UIView()
    
    
    //    MARK: - View Life Cycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.createCircles()
        addAnimationToTheCircles()
    }
    
    
    //    MARK: - Action Methods
    
    @IBAction func btnShowProgressTapped(sender: AnyObject)
    {
        self.view.addSubview(self.vwCircleParent)
    }
    
    @IBAction func btnHideProgressTapped(sender: AnyObject)
    {
        self.vwCircleParent.removeFromSuperview()
    }
    
    //    MARK: - Other Methods
    
    private func createCircles ()
    {
        vwCircleParent = UIView(frame: CGRect(x: view.frame.midX - 125, y: view.frame.midY - 40 , width: 250, height: 80))
        
        var circleWidth = 2 * circleRadius * CGFloat(intNumberOfCircles) + CGFloat(intNumberOfCircles - 1) * spaceBetweenCircles
        if circleWidth > CGRectGetWidth(self.vwCircleParent.frame)
        {
            circleWidth = CGRectGetWidth(self.vwCircleParent.frame)
        }
        
        let xOffset = (CGRectGetWidth(self.vwCircleParent.frame) - circleWidth) / 2
        
        let yPos = (CGRectGetHeight(self.vwCircleParent.frame) - 2 * circleRadius) / 2
        
        for i in 0..<intNumberOfCircles
        {
            let posX = xOffset + CGFloat(i) * ((2 * circleRadius) + spaceBetweenCircles)
            let circle = addImageToTheCircle(circleRadius, xPos: posX, yPos: yPos)
            circle.transform = CGAffineTransformMakeScale(0, 0)
            
            self.vwCircleParent.addSubview(circle)
        }
    }
    
    private func addImageToTheCircle(radius: CGFloat, xPos: CGFloat, yPos: CGFloat) -> UIView
    {
        let imgCircle = UIImage(named: "TAG_Icon.png")
        let imageView = UIImageView(image: imgCircle)
        
        imageView.frame = CGRect(x: xPos, y: yPos, width: radius * 2, height: radius * 2)
        imageView.contentMode = UIViewContentMode.Center
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        return imageView
    }
    
    private func addAnimationToTheCircles ()
    {
        for i in 0..<self.vwCircleParent.subviews.count
        {
            let subview = self.vwCircleParent.subviews[i]
            subview.layer.removeAnimationForKey("scale")
            subview.layer.addAnimation(self.addAnimation(duration, delay: Double(i) * delay), forKey: "scale")
        }
    }
    
    private func addAnimation(duration: Double, delay: Double) -> CABasicAnimation
    {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        
        animation.delegate = self
        animation.fromValue = 0
        animation.toValue = 1
        animation.autoreverses = true
        animation.duration = duration
        animation.removedOnCompletion = false
        animation.beginTime = CACurrentMediaTime() + delay
        animation.repeatCount = MAXFLOAT
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return animation
    }
}