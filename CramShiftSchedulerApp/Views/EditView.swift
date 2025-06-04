import SwiftUI

/// OCR結果をグリッド表示し編集を行うビュー
struct EditView: View {
    @ObservedObject var ocrViewModel: OCRViewModel
    @State private var selectedDay: String = "月曜日"
    @State private var memo: String = ""
    @State private var showShare = false
    @State private var outputImage: UIImage?
    @StateObject private var renderer = RendererViewModel()

    let days = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]

    var body: some View {
        VStack {
            Picker("曜日", selection: $selectedDay) {
                ForEach(days, id: \.self) { Text($0) }
            }
            .pickerStyle(.segmented)

            HStack {
                gridSection

                VStack(alignment: .leading) {
                    Text("未配置")
                    List(ocrViewModel.unplacedTeachers) { teacher in
                        Text(teacher.name)
                    }
                    .frame(width: 120)
                }
            }
            
            Text("備考欄")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            TextEditor(text: $memo)
                .border(Color.gray)
                .frame(height: 100)
        }
        .padding()
        .navigationTitle("編集")
        .toolbar {
            Button("生成") {
                outputImage = renderer.render(assignments: ocrViewModel.assignments, day: selectedDay, memo: memo)
                showShare = true
            }
        }
        .sheet(isPresented: $showShare) {
            if let image = outputImage {
                ShareSheet(activityItems: [image])
            }
        }
    }

    private var gridSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
            ForEach(ocrViewModel.assignments) { assignment in
                Text(assignment.teacherName)
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(4)
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(ocrViewModel: OCRViewModel())
    }
}
