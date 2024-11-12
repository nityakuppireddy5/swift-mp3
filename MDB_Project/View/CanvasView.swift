//
//  CanvasView.swift
//  MDB-Project
//
//  Created by Brayton Lordianto and Amol Budhiraja on 9/30/24.
//

import SwiftUI
import PencilKit

struct CanvasView: View {
    @Binding var drawing: DrawingModel
    @State private var imagesToOverlay: [OverlayImageModel] = [] // Array for multiple overlay images
    @State var imageToOverlay: UIImage? = nil
    @State var takingPhoto: Bool = false
    @State private var isShowingShareSheet = false
    @State private var imageToShare: UIImage? = nil
    @State private var currentImageScale: CGFloat = 1.0 // Updated variable name for clarity

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                // Add buttons for camera, eraser, and export here
                // Camera Button
                Button(action: {
                    takingPhoto = true
                }) {
                    Image(systemName: "camera")
                        .font(.system(size: 24))
                        .padding()
                }
                
                // Eraser Button
                Button(action: {
                    drawing.canvas.drawing = PKDrawing() // Clear the canvas
                    imagesToOverlay.removeAll() // Clear overlay images
                }) {
                    Image(systemName: "eraser")
                        .font(.system(size: 24))
                        .padding()
                }
                
                // Export Button
                Button(action: {
                    if let exportableView = drawing.createExportableView() {
                        imageToShare = exportableView.asImage()
                        isShowingShareSheet = true
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 24))
                        .padding()
                }
                
                Spacer()
            }
            
            ZStack {
                DrawSpace(drawing: $drawing)
                    .edgesIgnoringSafeArea(.top)
                            
                    // Display each overlay image as a separate draggable, resizable view
                    ForEach(imagesToOverlay.indices, id: \.self) { index in
                        GeometryReader { geometry in
                            let overlay = $imagesToOverlay[index]
                            Image(uiImage: overlay.wrappedValue.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(overlay.wrappedValue.scale)
                                .position(overlay.wrappedValue.position)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            overlay.wrappedValue.scale = value.magnitude // Adjust scale
                                        }
                                        .simultaneously(with: DragGesture()
                                            .onChanged { gesture in
                                                overlay.wrappedValue.position = gesture.location // Update position
                                            }
                                        )
                                )
                    }
                }
            }
        }
        .sheet(isPresented: $takingPhoto) {
            // Display ImagePicker when the camera is tapped
            ImagePicker(image: $imageToOverlay)
        }
        .onChange(of: imageToOverlay) { newValue in
            // Implement logic to overlay selected image onto the canvas
            if let newImage = newValue {
                //drawing.overlayImage(image: newImage)
                imagesToOverlay.append(
                OverlayImageModel(
                    image: newImage,
                    scale: 1.0,
                    position: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    )
                )
            imageToOverlay = nil // Reset after adding
            }
        }
        .sheet(isPresented: $isShowingShareSheet) {
            // Present the share sheet with the generated image
            if let image = imageToShare {
                ShareSheet(activityItems: [image])
            }
        }
    }
}
// Model for each overlay image, tracking its image, scale, and position
struct OverlayImageModel: Identifiable {
    let id = UUID()
    var image: UIImage
    var scale: CGFloat
    var position: CGPoint
}
// Convert UIView to UIImage
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}

// ShareSheet Struct to Present UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Preview Provider
struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(drawing: .constant(DrawingModel()))
    }
}

