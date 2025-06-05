import SwiftUI

struct ContentView: View {
    @State private var showPicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage?
    @State private var showEdit = false
    @State private var showCameraAlert = false
    @StateObject private var ocrViewModel = OCRViewModel()

    var body: some View {
        HomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
