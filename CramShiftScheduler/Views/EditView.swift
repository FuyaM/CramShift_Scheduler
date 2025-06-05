import SwiftUI
import UniformTypeIdentifiers

/// OCR結果をグリッド表示し編集とプレビューを行うビュー
struct EditView: View {
    var image: UIImage?
    @ObservedObject var ocrViewModel: OCRViewModel
    @State private var selectedDay: String = "月曜日"
    @State private var memo: String = ""
    @State private var showShare = false
    @State private var outputImage: UIImage?
    @StateObject private var renderer = RendererViewModel()

    let days = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let img = image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }

                Picker("曜日", selection: $selectedDay) {
                    ForEach(days, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)

                HStack(alignment: .top, spacing: 20) {
                    gridSection

                    VStack(alignment: .leading) {
                        Text("未配置")
                        List(ocrViewModel.unplacedTeachers) { teacher in
                            Text(teacher.name)
                                .onDrag { NSItemProvider(object: teacher.name as NSString) }
                        }
                        .frame(width: 120, height: 300)
                    }

                    ExportView(assignments: ocrViewModel.assignments,
                               day: selectedDay,
                               memo: memo)
                        .frame(width: 250, height: 350)
                        .border(Color.gray)
                }

                Text("備考欄")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextEditor(text: $memo)
                    .border(Color.gray)
                    .frame(height: 100)
            }
            .padding()
        }
        .navigationTitle("編集")
        .toolbar {
            Button("生成") {
                outputImage = renderer.render(assignments: ocrViewModel.assignments,
                                             day: selectedDay,
                                             memo: memo)
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
        VStack {
            ForEach(SlotType.allCases, id: \.self) { slot in
                HStack {
                    ForEach(0..<3) { column in
                        ZStack {
                            Rectangle()
                                .stroke(Color.gray)
                                .frame(width: 80, height: 40)
                            if let a = ocrViewModel.assignments.first(where: { $0.startSlot == slot && $0.column == column }) {
                                Text(a.teacherName)
                            }
                        }
                        .onDrop(of: [.utf8PlainText], delegate: SlotDropDelegate(slot: slot, column: column, ocrViewModel: ocrViewModel))
                    }
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(image: nil, ocrViewModel: OCRViewModel())
    }
}

struct SlotDropDelegate: DropDelegate {
    let slot: SlotType
    let column: Int
    var ocrViewModel: OCRViewModel

    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: [.utf8PlainText]).first {
            item.loadItem(forTypeIdentifier: UTType.utf8PlainText.identifier, options: nil) { data, _ in
                if let data = data as? Data, let name = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        ocrViewModel.assign(teacherName: name, to: slot, column: column)
                    }
                }
            }
            return true
        }
        return false
    }
}
