//
//  OTPEntry.swift
//  MFA
//
//  Created by Daniel Kelly on 2/19/22.
//

import Foundation
import SwiftOTP

struct OTPEntry: Hashable, Codable, Identifiable {
    let id = UUID()
    var accountname: String
    var issuer: String
    
    private var secret: String
    private var secretData: Data {
        base32DecodeToData(secret)!
    }
    
    private func formatDisplayCode(password: String, chunkSize: Int) -> String {
        var mutablePassword = password
        for i in stride(from: chunkSize, to: mutablePassword.count, by: chunkSize).reversed() {
            mutablePassword.insert(" ", at: mutablePassword.index(mutablePassword.startIndex, offsetBy: i))
        }
        return mutablePassword
    }
    
    func generateCode(date: Date) -> String {
        formatDisplayCode(password: TOTP(secret: secretData)!.generate(time: date)!, chunkSize: 2)
    }
}
