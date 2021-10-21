//
//  PHAssetExtension.swift
//  BabyPhoto
//
//  Created by Thanh Vu on 7/20/20.
//  Copyright © 2020 Solar. All rights reserved.
//

import Foundation
import Photos
import UIKit
import MobileCoreServices

extension PHAsset {
    func thumbnail(size: CGSize = CGSize(width: 300, height: 300)) -> UIImage? {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        option.isSynchronous = true

        var result: UIImage?
        PHImageManager.default().requestImage(for: self, targetSize: size, contentMode: .aspectFill, options: option) {(image, _) in
            result = image
        }
        
        return result
    }
    
    func originalFileName() -> String? {
        if let resource = PHAssetResource.assetResources(for: self).first {
            return resource.originalFilename
        }
        
        return nil
    }
    
    static func fromLocalIdentifier(_ id: String) -> PHAsset? {
        let options = PHFetchOptions()
        options.fetchLimit = 1
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: options)
        return result.firstObject
    }

    func isGifType() -> Bool {
        if let identifier = self.value(forKey: "uniformTypeIdentifier") as? String {
             if identifier == kUTTypeGIF as String {
               return true
             }
        }
        
        return false
    }
}
