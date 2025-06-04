import SwiftUI

/// 編集済みデータから最終画像を生成する ViewModel
class RendererViewModel: ObservableObject {
    @MainActor func render(assignments: [SlotAssignment], day: String, memo: String) -> UIImage {
        let view = ExportView(assignments: assignments, day: day, memo: memo)
        let renderer = ImageRenderer(content: view)
        return renderer.uiImage ?? UIImage()
    }
}

/// 画像化用の SwiftUI View
struct ExportView: View {
    var assignments: [SlotAssignment]
    var day: String
    var memo: String

    var body: some View {
        VStack {
            Text(day)
                .font(.title)
                .padding()
            grid
            Text(memo)
                .font(.footnote)
                .padding()
        }
        .frame(width: 350, height: 500)
        .background(Color.white)
    }

    private var grid: some View {
        VStack(alignment: .leading) {
            ForEach(SlotType.allCases, id: \.self) { slot in
                HStack {
                    Text("\(slot.rawValue)コマ")
                        .frame(width: 60, alignment: .leading)
                    ForEach(assignments.filter { $0.startSlot == slot }) { a in
                        Text(a.teacherName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
}
