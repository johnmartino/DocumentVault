import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var authService = AuthenticationService()
    @State private var lockImageName: String = "lock"
    @State private var message = "Press the button to authenticate"
    @State private var isAuthenticating = false
    
    var body: some View {
        VStack {
            Button {
                authenticate()
            } label: {
                Image(systemName: lockImageName)
                    .foregroundStyle(.white)
            }
            .padding()
            .background(.clear, in: .circle)
            .glassEffect(.regular.tint(.blue))
            
            if isAuthenticating {
                ProgressView {
                    Text("Authenticating")
                }
            } else {
                HStack {
                    Text(message)
                        .multilineTextAlignment(.leading)
                        .padding()
                    if !message.isEmpty {
                        Button {
                            message = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.small)
                                .tint(.gray)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .task {
            lockImageName = await authService.biometricImageName
        }
    }
    
    private func authenticate() {
        Task { @MainActor in
            do {
                isAuthenticating = true
                let success = try await authService.authenticate()
                message = success ? "Authentication succeeded" : "Authentication failed"
                isAuthenticating = false
            } catch {
                message = error.localizedDescription
                isAuthenticating = false
            }
        }
    }
}

#Preview {
    ContentView()
}
