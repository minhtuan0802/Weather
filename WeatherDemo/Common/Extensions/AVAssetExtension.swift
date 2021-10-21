//
//  AVAssetExtension.swift
//  BabyPhoto
//
//  Created by Le Toan on 9/10/20.
//  Copyright © 2020 Solar. All rights reserved.
//

import AVFoundation
import UIKit

extension AVAsset {
    var thumbnailImage: UIImage {
        var image = UIImage()
        do {
            let imgGenerator = AVAssetImageGenerator(asset: self)
            let cgImage = try! imgGenerator.copyCGImage(at: .zero, actualTime: nil)
            image = UIImage.init(cgImage: cgImage, scale: 1, orientation: image.imageOrientation)
            image = image.resize(to: CGSize(width: 800, height: 800))
        }
        
        return image
    }
}
