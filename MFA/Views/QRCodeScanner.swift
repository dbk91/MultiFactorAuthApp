//
//  QRCodeScanner.swift
//  MFA
//
//  Created by Daniel Kelly on 2/27/22.
//

import SwiftUI
import AVFoundation
import CodeScanner

struct QRCodeScanner: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData
    
    @StateObject private var otpEntry = OTPEntry()
    
    @State private var message = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    let videoAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                }
                .padding()
                
                ZStack {
                    CodeScannerView(codeTypes: [.qr], scanMode: .continuous, scanInterval: 1.0, showViewfinder: videoAuthorizationStatus == .authorized) { response in
                        switch response {
                        case .success(let result):
                            let url = URL(string: result.string)!
                            
                            do {
                                let otpEntry = try OTPEntry(url: url)
                                modelData.otpEntries.append(otpEntry)
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                showAlert = true
                            }
                        case .failure(let error):
                            message = error.localizedDescription
                        }
                    }
                    .alert("Failed to Scan", isPresented: $showAlert) {
                        Button("Okay") {
                            showAlert = false
                        }
                    } message: {
                        Text("The scanned token is invalid")
                    }
                    
                    if videoAuthorizationStatus != .authorized {
                        VStack {
                            Text("This application requires camera permissions")
                                .padding(.bottom)
                            
                            Link("Go to Settings", destination: URL(string: UIApplication.openSettingsURLString)!)
                        }
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    OTPForm()
                } label: {
                    Label("Add Details Manually", systemImage: "plus.circle")
                        .padding()
                }
            }
            .navigationBarHidden(true)
            .navigationTitle("Code Scanner")
        }
    }
}

struct QRCodeScanner_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScanner()
            .environmentObject(ModelData())
    }
}
