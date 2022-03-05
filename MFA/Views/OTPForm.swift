//
//  OTPForm.swift
//  MFA
//
//  Created by Daniel Kelly on 3/3/22.
//

import SwiftUI

enum Algorithm: String, CaseIterable, Identifiable {
    case sha1, sha256, sha512
    var id: Self { self }
}

struct OTPForm: View {
    @State private var accountname = ""
    @State private var secret = ""
    @State private var issuer = ""
    @State private var algorithm: Algorithm = .sha1
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Account Name", text: $issuer)
                TextField("Secret", text: $issuer)
                TextField("Issuer", text: $issuer)
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

struct OTPForm_Previews: PreviewProvider {
    static var previews: some View {
        OTPForm()
    }
}
