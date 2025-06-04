import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("講師管理") {
                    TeacherListView()
                }
                Button("写真を撮る") {
                    // Camera action placeholder
                }
                Button("ライブラリから選択") {
                    // Photo library action placeholder
                }
            }
            .navigationTitle("ホーム")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
