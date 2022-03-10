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
    @State private var message = ""
    
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
                    CodeScannerView(codeTypes: [.qr], showViewfinder: videoAuthorizationStatus == .authorized) { response in
                        switch response {
                        case .success(let result):
                            let url = URL(string: result.string)!
                            var components = URLComponents()
                            components.query = url.fragment
                        case .failure(let error):
                            message = error.localizedDescription
                        }
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
    }
}
