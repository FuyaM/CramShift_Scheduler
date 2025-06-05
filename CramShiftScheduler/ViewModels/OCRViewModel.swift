import Foundation
import Vision
import SwiftUI

/// OCR処理を行い、SlotAssignment を構築する ViewModel
class OCRViewModel: ObservableObject {
    @Published var assignments: [SlotAssignment] = []
    @Published var unplacedTeachers: [Teacher] = []

    var registeredTeachers: [Teacher] = []

    /// 画像からテキスト認識を実行する
    func recognize(from image: CGImage) {
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            self?.processObservations(observations)
        }
        request.recognitionLanguages = ["ja-JP"]
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        try? handler.perform([request])
    }

    /// 認識結果を講師名リストと照合し、SlotAssignment 配列を作成する
    private func processObservations(_ observations: [VNRecognizedTextObservation]) {
        var detected: [SlotAssignment] = []
        for o in observations {
            guard let best = o.topCandidates(1).first else { continue }
            if let teacher = registeredTeachers.first(where: { $0.name == best.string }) {
                // TODO: バウンディングボックスから startSlot を推定する処理
                let column = detected.filter { $0.startSlot == .A }.count
                let assignment = SlotAssignment(teacherName: teacher.name, startSlot: .A, column: column, span: 1)
                detected.append(assignment)
            }
        }
        DispatchQueue.main.async {
            self.assignments = detected
            self.updateUnplaced()
        }
    }

    /// 未配置講師リストを更新
    private func updateUnplaced() {
        let placedNames = Set(assignments.map { $0.teacherName })
        unplacedTeachers = registeredTeachers.filter { !placedNames.contains($0.name) }
    }

    /// ドロップ操作などで講師を指定のマスへ配置する
    func assign(teacherName: String, to slot: SlotType, column: Int) {
        assignments.removeAll { $0.startSlot == slot && $0.column == column }
        let assignment = SlotAssignment(teacherName: teacherName, startSlot: slot, column: column, span: 1)
        assignments.append(assignment)
        unplacedTeachers.removeAll { $0.name == teacherName }
    }
}
