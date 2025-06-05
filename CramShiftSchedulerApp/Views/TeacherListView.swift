import SwiftUI

struct TeacherListView: View {
    @ObservedObject var viewModel: TeacherListViewModel
    @State private var editingTeacher: Teacher?
    @State private var newName: String = ""
    @State private var showModal = false

    var body: some View {
        List {
            ForEach(viewModel.teachers) { teacher in
                Text(teacher.name)
                    .onTapGesture {
                        editingTeacher = teacher
                        newName = teacher.name
                        showModal = true
                    }
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle("講師リスト")
        .toolbar {
            Button("追加") {
                newName = ""
                editingTeacher = nil
                showModal = true
            }
        }
        .sheet(isPresented: $showModal) {
            NavigationView {
                Form {
                    TextField("名前", text: $newName)
                }
                .navigationTitle(editingTeacher == nil ? "追加" : "編集")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("キャンセル") { showModal = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("保存") {
                            if let teacher = editingTeacher {
                                viewModel.update(teacher: teacher, name: newName)
                            } else {
                                viewModel.add(name: newName)
                            }
                            showModal = false
                        }
                    }
                }
            }
        }
    }
}

struct TeacherListView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherListView(viewModel: TeacherListViewModel())
    }
}
