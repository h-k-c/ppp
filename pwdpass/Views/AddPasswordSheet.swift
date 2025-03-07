import SwiftUI

struct AddPasswordSheet: View {
    @Environment(\.dismiss) private var dismiss
    let addPassword: (PasswordItem) -> Void
    
    @State private var note = ""
    @State private var password = ""
    @State private var showPassword = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("新增密码")
                    .font(.title3.bold())
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("备注")
                        .foregroundStyle(.secondary)
                    TextField("请输入备注信息", text: $note)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("密码")
                        .foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        Group {
                            if showPassword {
                                TextField("请输入密码", text: $password)
                            } else {
                                SecureField("请输入密码", text: $password)
                            }
                        }
                        .textFieldStyle(.roundedBorder)
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundStyle(.gray)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("取消", role: .cancel) {
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Button("确定") {
                    guard !note.isEmpty && !password.isEmpty else { return }
                    let newItem = PasswordItem(
                        note: note,
                        password: password
                    )
                    addPassword(newItem)
                    dismiss()
                }
                .keyboardShortcut(.return)
                .buttonStyle(.borderedProminent)
                .disabled(note.isEmpty || password.isEmpty)
            }
        }
        .padding()
        .frame(width: 360, height: 380)
    }
}

// MARK: - Previews
struct AddPasswordSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddPasswordSheet { _ in }
    }
} 