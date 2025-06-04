import Foundation

/// 授業コマの種類
enum SlotType: String, Codable, CaseIterable {
    case Z, A, B, C, D
}

/// 講師のコマ割り情報
struct SlotAssignment: Identifiable, Codable {
    var id = UUID()
    var teacherName: String
    var startSlot: SlotType
    var span: Int
}
