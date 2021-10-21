//
//  UIImageExtensions.swift
//  BabyPhoto
//
//  Created by Thanh Vu on 6/24/20.
//  Copyright © 2020 Solar. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
      let rect = CGRect(origin: .zero, size: size)
      UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
      color.setFill()
      UIRectFill(rect)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      guard let cgImage = image?.cgImage else { return nil }
      self.init(cgImage: cgImage)
    }
}

extension UIImage {
    
    static func getImagesFromGifData(_ data: Data) -> [UIImage] {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return [] }
        let frameCount = CGImageSourceGetCount(imageSource)
        var frames = [UIImage]()

        for index in 0..<frameCount {
            if let imageRef = CGImageSourceCreateImageAtIndex(imageSource, index, nil) {
                let image = UIImage(cgImage: imageRef)
                frames.append(image)
            }
        }

        return frames
    }
    
    static func firstFrameFrom(gifURL: URL) -> UIImage? {
        guard let imageData = try? Data(contentsOf: gifURL) else {
            return nil
        }
        
        return self.getFirstFrameOfGifData(imageData)
    }

    static func getFirstFrameOfGifData(_ data: Data) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let frameCount = CGImageSourceGetCount(imageSource)
        if frameCount == 0 {
            return nil
        }

        if let imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) {
            return UIImage(cgImage: imageRef)
        }

        return nil
    }

    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(origin: CGPoint.zero, size:size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }

    func crop(rect: CGRect) -> UIImage {
        guard let cgImage = self.cgImage else {
            return self
        }
        
        guard let cropImage = cgImage.cropping(to: rect) else {
            return self
        }
        
        return UIImage.init(cgImage: cropImage) 
    }

    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect.init(origin: .zero, size: size))
        let normalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalImage ?? self
    }
    
    func resizeAspectFit(to size: CGSize, backgroundColor: UIColor) -> UIImage? {
        let pdfRect = CGRect.init(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(pdfRect.size, false, 0.0)
        backgroundColor.setFill()
        UIRectFill(pdfRect)
        
        let resizeImage = self.resizeToFit(fitSize: size)
        
        guard let imageData = resizeImage.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        guard let jpegImage = UIImage.init(data: imageData) else {
            return nil
        }
        
        let drawRect = CGRect.init(x: (size.width - jpegImage.size.width) / 2, y: (size.height - jpegImage.size.height) / 2, width: jpegImage.size.width, height: jpegImage.size.height)
        
        jpegImage.draw(in: drawRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeToFill(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let insetLeft = (self.size.width - size.width)/2
        let insetTop = (self.size.height - size.height)/2
        
        self.draw(at: CGPoint(x: -insetLeft, y: -insetTop))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func resizeToFit(fitSize: CGSize) -> UIImage {
        var targetSize: CGSize
        
        if self.size.height / self.size.width < fitSize.height/fitSize.width {
            targetSize = CGSize(width: fitSize.width, height: fitSize.width / self.size.width * self.size.height)
        } else {
            targetSize = CGSize(width: fitSize.height / self.size.height * self.size.width, height: fitSize.height)
        }
        
        return self.resize(to: targetSize)
    }
    
    func makeSquareImage(withBackgroundColor bgColor: UIColor) -> UIImage {
        let size = CGFloat.maximum(self.size.width, self.size.height)
        let contextSize = CGSize(width: size, height: size)
        UIGraphicsBeginImageContext(contextSize)
        bgColor.setFill()
        let context = UIGraphicsGetCurrentContext()
        context?.fill(CGRect(origin: .zero, size: contextSize))
        
        let drawLocation = CGPoint(x: (contextSize.width - self.size.width)/2, y: (contextSize.height - self.size.height)/2)
        self.draw(at: drawLocation)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIImage {
    func merge(in viewSize: CGSize, with imageTuples: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.scaleBy(x: size.width / viewSize.width, y: size.height / viewSize.height)

        draw(in: CGRect(origin: .zero, size: viewSize), blendMode: .normal, alpha: 1)

        for imageTuple in imageTuples {
            let areaRect = CGRect(origin: .zero, size: imageTuple.viewSize)

            context.saveGState()
            context.concatenate(imageTuple.transform)

            context.setBlendMode(.color)
            UIColor.clear.setFill()
            context.fill(areaRect)

            imageTuple.image.draw(in: areaRect, blendMode: .normal, alpha: 1)

            context.restoreGState()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return UIImage()
        }
    }
}
