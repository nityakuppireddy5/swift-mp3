//
//  DrawingViewModel.swift
//  MDB-Project
//
//  Created by Brayton Lordianto on 9/30/24.
//

import Foundation
import UIKit
import PencilKit

struct DrawingModel {
    var canvas: PKCanvasView
    var name: String
    var isSelected: Bool = false
    var overlaidImages = [overlaidImage]()
    var idImage = UIImage()

    struct overlaidImage {
        // Define properties for an image, its position (center), scale, and rotation
        var image: UIImage
        var position: CGPoint
        var scale: CGFloat
        var rotation: CGFloat

        init(image: UIImage, position: CGPoint = .zero, scale: CGFloat = 1.0, rotation: CGFloat = 0.0) {
            self.image = image
            self.position = position
            self.scale = scale
            self.rotation = rotation
        }
    }

    init() {
        self.canvas = .init()
        self.name = "untitled"
    }
}

extension DrawingModel  {
    func overlayImage(image: UIImage) {
        // Implement adding an image as a subview to the canvas
        let canvasViewCopy = UIView(frame: canvas.bounds)
        
        // Add the original canvas drawing to the view
        let drawingImageView = UIImageView(image: canvas.drawing.image(from: canvas.bounds, scale: 1.0))
        canvasViewCopy.addSubview(drawingImageView)
        
        // Prepare the new overlaid image
        let overlayImageView = UIImageView(image: image)
        overlayImageView.center = canvas.center
        overlayImageView.contentMode = .scaleAspectFit
        
        // Add the overlaid image view on top of the drawing
        canvasViewCopy.addSubview(overlayImageView)
        
        //return canvasViewCopy
    }
    
    func createExportableView() -> UIView? {
        // Implement logic to capture the canvas and create a snapshot image
        let exportableView = UIView(frame: canvas.bounds)
        
        // Render the base drawing of the canvas as an image and add to the view
        let drawingImageView = UIImageView(image: canvas.drawing.image(from: canvas.bounds, scale: 1.0))
        exportableView.addSubview(drawingImageView)
        
        // Add each overlaid image on top of the drawing in the exportable view
        for overlay in overlaidImages {
            let imageView = UIImageView(image: overlay.image)
            imageView.center = overlay.position
            imageView.transform = CGAffineTransform(rotationAngle: overlay.rotation).scaledBy(x: overlay.scale, y: overlay.scale)
            exportableView.addSubview(imageView)
        }
        
        return exportableView
    }
}

class DrawingViewModel: ObservableObject {
    @Published var drawing = DrawingModel()
}
