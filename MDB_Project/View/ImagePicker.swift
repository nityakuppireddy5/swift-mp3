//
//  ImagePicker.swift
//  MDB-Project
//
//  Created by Brayton Lordianto on 9/30/24.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Dismiss the picker and handle the selected image
            picker.dismiss(animated: true)
                        
                        // Handle the selected image
                        guard let result = results.first else { return }
                        
                        // Check if the result can provide an image
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let uiImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.parent.image = uiImage
                        }
                    }
                }
            }
        }
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        // Configure the PHPicker to select images only
        var configuration = PHPickerConfiguration()
                configuration.filter = .images // Only allow image selection
                configuration.selectionLimit = 1 // Allow only one image to be selected

                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = context.coordinator
                return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
