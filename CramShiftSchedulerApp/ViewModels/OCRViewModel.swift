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
                let midY = o.boundingBox.midY
                let slot: SlotType
                switch midY {
                case 0.8...1.0: slot = .Z
                case 0.6..<0.8: slot = .A
                case 0.4..<0.6: slot = .B
                case 0.2..<0.4: slot = .C
                default: slot = .D
                }
                let assignment = SlotAssignment(teacherName: teacher.name, startSlot: slot, span: 1)
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
}
