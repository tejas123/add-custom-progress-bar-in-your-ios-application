//
//  ProgressWithTextViewController.swift
//  ProgressIndicator
//
//  Created by Niks on 15/12/15.
//  Copyright © 2015 TheAppGuruz. All rights reserved.
//

import UIKit

class ProgressWithTextViewController: UIViewController, CustomPhotoAlbumDelegate
{
    @IBOutlet weak var imageView: UIImageView!

    var btnSave = UIBarButtonItem()
    
    var vwProgressPopup = UIView()
    var progressActivityIndicator = UIActivityIndicatorView()
    var lblMessage = UILabel()
    
    
    //    MARK: - View Life Cycle Methods
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor(white: 0.3, alpha: 1)
        imageView.image = UIImage(named: "TableTennis.png")
        
        btnSave = UIBarButtonItem.init(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("startSavingImage"))
        self.navigationItem.rightBarButtonItem = btnSave
        
        SaveImageUtility.sharedInstance.delegate = self
    }
    
    
    //    MARK: - CustomPhotoAlbumDelegate Methods
    
    func photosSaveFailed()
    {
        print("Image Save Failed")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.vwProgressPopup.removeFromSuperview()
            self.btnSave.enabled = true
        }
    }
    
    func photosSaveSuccessfully()
    {
        print("Image Save Successful")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.vwProgressPopup.removeFromSuperview()
            self.btnSave.enabled = true
        }
    }
    
    
    //    MARK: - Other Methods
    
    func showProgress(msg:String, withIndicator: Bool)
    {
        lblMessage = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        lblMessage.text = msg
        lblMessage.textColor = UIColor.whiteColor()
        vwProgressPopup = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        vwProgressPopup.layer.cornerRadius = 15
        vwProgressPopup.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        if (withIndicator)
        {
            progressActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            progressActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            progressActivityIndicator.startAnimating()
            vwProgressPopup.addSubview(progressActivityIndicator)
        }
        
        vwProgressPopup.addSubview(lblMessage)
        view.addSubview(vwProgressPopup)
    }
    
    func saveImage()
    {
        SaveImageUtility.sharedInstance.saveImage(imageView.image!)
    }
    
    func startSavingImage()
    {
        btnSave.enabled = false
        showProgress("Saving Image", withIndicator: true)
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.saveImage()
        }
    }
}