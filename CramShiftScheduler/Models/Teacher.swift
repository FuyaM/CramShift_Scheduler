import Foundation

struct Teacher: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
}
