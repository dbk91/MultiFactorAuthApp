//
//  MFAApp.swift
//  MFA
//
//  Created by Daniel Kelly on 2/19/22.
//

import SwiftUI

@main
struct MFAApp: App {
    var body: some Scene {
        WindowGroup {
            OTPList(otpEntries: otpEntries)
        }
    }
}
