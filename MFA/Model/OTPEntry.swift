//
//  OTPEntry.swift
//  MFA
//
//  Created by Daniel Kelly on 2/19/22.
//

import Foundation
import SwiftOTP

enum Algorithm: String, CaseIterable, Identifiable {
    case sha1, sha256, sha512
    var id: Self { self }
}

enum CodingKeys: CodingKey {
    case accountname, issuer, secret
}

enum OTPError: Error {
    case InvalidURLScheme
    case MissingParams
}

class OTPEntry: ObservableObject, Codable, Identifiable {
    init() { }
    
    init(url: URL) throws {
        if url.scheme != "otpauth" {
            throw OTPError.InvalidURLScheme
        }
        
        var components = URLComponents()
        components.query = url.query
        
        if (url.lastPathComponent.contains(":")) {
            let pathComponents = url.lastPathComponent.components(separatedBy: ":")
            accountname = pathComponents[pathComponents.endIndex - 1]
        } else {
            accountname = url.lastPathComponent
        }
        
        for query in components.queryItems! {
            switch query.name {
            case "secret":
                secret = query.value!
            case "issuer":
                issuer = query.value!
            default:
                continue;
            }
        }
        
        if secret.isEmpty || issuer.isEmpty {
            throw OTPError.MissingParams
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accountname = try container.decode(String.self, forKey: .accountname)
        issuer = try container.decode(String.self, forKey: .issuer)
        secret = try container.decode(String.self, forKey: .secret)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(accountname, forKey: .accountname)
        try container.encode(issuer, forKey: .issuer)
        try container.encode(secret, forKey: .secret)
    }
    
    let id = UUID()
    @Published var accountname = ""
    @Published var issuer = ""
    
    @Published var secret = ""
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
