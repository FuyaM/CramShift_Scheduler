import SwiftUI

struct HomeView: View {
    @State private var showPicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage?
    @State private var showEdit = false
    @State private var showCameraAlert = false
    @StateObject private var ocrViewModel = OCRViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("講師管理") {
                    TeacherListView()
                }
                Button("写真を撮る") {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        pickerSource = .camera
                        showPicker = true
                    } else {
                        showCameraAlert = true
                    }
                }
                Button("ライブラリから選択") {
                    pickerSource = .photoLibrary
                    showPicker = true
                }
                NavigationLink(destination: EditView(image: image, ocrViewModel: ocrViewModel), isActive: $showEdit) {
                    EmptyView()
                }
            }
            .navigationTitle("ホーム")
        }
        .sheet(isPresented: $showPicker, onDismiss: loadImage) {
            ImagePicker(sourceType: pickerSource, image: $image)
        }
        .alert("カメラを利用できません", isPresented: $showCameraAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    private func loadImage() {
        guard let cgImage = image?.cgImage else { return }
        ocrViewModel.recognize(from: cgImage)
        showEdit = true
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
