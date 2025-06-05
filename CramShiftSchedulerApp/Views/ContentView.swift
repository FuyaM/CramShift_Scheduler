import SwiftUI

struct ContentView: View {
    @State private var showPicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage?
    @State private var showEdit = false
    @StateObject private var teacherList = TeacherListViewModel()
    @StateObject private var ocrViewModel = OCRViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                NavigationLink {
                    TeacherListView(viewModel: teacherList)
                } label: {
                    Label("講師管理", systemImage: "person.3.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    pickerSource = .camera
                    showPicker = true
                } label: {
                    Label("写真を撮る", systemImage: "camera.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    pickerSource = .photoLibrary
                    showPicker = true
                } label: {
                    Label("ライブラリから選択", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                NavigationLink(destination: EditView(ocrViewModel: ocrViewModel), isActive: $showEdit) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("ホーム")
        }
        .sheet(isPresented: $showPicker, onDismiss: loadImage) {
            ImagePicker(sourceType: pickerSource, image: $image)
        }
    }

    private func loadImage() {
        guard let cgImage = image?.cgImage else { return }
        ocrViewModel.registeredTeachers = teacherList.teachers
        ocrViewModel.recognize(from: cgImage)
        showEdit = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
