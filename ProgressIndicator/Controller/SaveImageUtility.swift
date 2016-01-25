//
//  SaveImageUtility.swift
//  ProgressIndicator
//
//  Created by Niks on 16/12/15.
//  Copyright © 2015 TheAppGuruz. All rights reserved.
//

import Photos

protocol CustomPhotoAlbumDelegate
{
    func photosSaveFailed()
    func photosSaveSuccessfully()
}

class SaveImageUtility
{
    static let strAlbumName = "TheAppGuruz"
    static let sharedInstance = SaveImageUtility()
    var delegate: CustomPhotoAlbumDelegate?
    
    var assetCollection: PHAssetCollection!
    
    init()
    {
        func fetchAssetCollectionForAlbum() -> PHAssetCollection!
        {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", SaveImageUtility.strAlbumName)
            let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
            
            if let _: AnyObject = collection.firstObject {
                return collection.firstObject as! PHAssetCollection
            }
            
            return nil
        }
        
        if let assetCollection = fetchAssetCollectionForAlbum()
        {
            self.assetCollection = assetCollection
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(SaveImageUtility.strAlbumName)
            }) { success, _ in
                if success
                {
                    self.assetCollection = fetchAssetCollectionForAlbum()
                }
        }
    }
    
    func saveImage(image: UIImage)
    {
        if assetCollection == nil
        {
            return   // If there was an error upstream, skip the save.
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
            albumChangeRequest!.addAssets([assetPlaceholder!])
            }, completionHandler:  { success, error in
                if (success)
                {
                    self.delegate?.photosSaveSuccessfully()
                }
                else
                {
                    print(error)
                    self.delegate?.photosSaveFailed()
                }
                
        })
    }
}