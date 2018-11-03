//
//  ViewController.swift
//  MLCoreExample
//
//  Created by Роман Смоляков on 03/11/2018.
//  Copyright © 2018 Роман Смоляков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelCategory: UILabel!

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    let model = GoogLeNetPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        img1.isUserInteractionEnabled = true
        img1.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        img2.isUserInteractionEnabled = true
        img2.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        img3.isUserInteractionEnabled = true
        img3.addGestureRecognizer(tapGestureRecognizer)	
    }

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imageView = tapGestureRecognizer.view as? UIImageView
        
        if let imageToAnalyse = imageView?.image {
                let scaledImage = scaleImage(image: imageToAnalyse, toSize: CGSize(width: 224, height: 224))
            if let sceneLabelString = sceneLabel(forImage: scaledImage) {
                labelCategory.text = sceneLabelString
            }
        }
    }
    
//    @objc func imageTapped(sender: UITapGestureRecognizer) {
//        let imageView = sender.view as? UIImageView
//
//        if let imageToAnalyse = imageView?.image {
//            if let sceneLabelString = sceneLabel(forImage: imageToAnalyse) {
//                labelCategory.text = sceneLabelString
//            }
//        }
//    }
    
    func sceneLabel (forImage image: UIImage) -> String? {
        
        if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: image.cgImage!) {
            guard let scene = try? model.prediction(sceneImage: pixelBuffer)
                else {fatalError("Unexpected runtime error!")}
            return scene.sceneLabel
        }
   
        return nil
    }
    
    func scaleImage(image: UIImage, toSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
