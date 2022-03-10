//
//  OTPForm.swift
//  MFA
//
//  Created by Daniel Kelly on 3/3/22.
//

import SwiftUI

struct OTPForm: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData
    
    @StateObject private var otpEntry = OTPEntry()
    
    @State private var algorithm: Algorithm = .sha1
    @State private var entryAdded = false
    
    @FocusState private var isAccountNameFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button("Add Code") {
                    modelData.otpEntries.append(otpEntry)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.horizontal)
            }
            
            Form {
                Section(header: Text("Details")) {
                    TextField("Account Name", text: $otpEntry.accountname)
                        .focused($isAccountNameFocused)
                    TextField("Secret", text: $otpEntry.secret)
                    TextField("Issuer", text: $otpEntry.issuer)
                }
                
                Section(header: Text("Advanced (Optional)")) {
                    Picker("Algorithm", selection: $algorithm) {
                        ForEach(Algorithm.allCases) { a in
                            Text(a.rawValue.uppercased())
                        }
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct OTPForm_Previews: PreviewProvider {
    static var previews: some View {
        OTPForm()
            .environmentObject(ModelData())
    }
}
