//
//  ContentView.swift
//  MDB-Project
//
//  Created by Brayton Lordianto on 9/30/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var drawingViewModel = DrawingViewModel()
    var body: some View {
        VStack(alignment: .center) {
            // Create a title for your app here using a SwiftUI Text view
            // Use modifiers like .bold() and .font(.title) to style the text
            // Title for the app
            Text("Drawing App")
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(.white)
            // Add the CanvasView here and pass the drawing model to it
            CanvasView(drawing: $drawingViewModel.drawing)
                .edgesIgnoringSafeArea(.all)
        }
        .background(Color.black) // Set background color to black
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

