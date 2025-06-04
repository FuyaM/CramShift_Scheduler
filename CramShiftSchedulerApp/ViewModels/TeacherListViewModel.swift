import Foundation
import SwiftUI

/// 講師名の読み込みや保存を担当する ViewModel
class TeacherListViewModel: ObservableObject {
    @Published var teachers: [Teacher] = []
    private let key = "teachers"

    init() {
        load()
    }

    /// UserDefaults から講師名を読み込む
    func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([Teacher].self, from: data) {
            teachers = saved
        }
    }

    /// 講師名を保存する
    private func save() {
        if let data = try? JSONEncoder().encode(teachers) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func add(name: String) {
        let teacher = Teacher(name: name)
        teachers.append(teacher)
        save()
    }

    func update(teacher: Teacher, name: String) {
        if let index = teachers.firstIndex(of: teacher) {
            teachers[index].name = name
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        teachers.remove(atOffsets: offsets)
        save()
    }
}
