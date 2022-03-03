//
//  OTPDetail.swift
//  MFA
//
//  Created by Daniel Kelly on 2/27/22.
//

import SwiftUI

struct OTPDetail: View {
    var otpEntry: OTPEntry
    var date: Date
    
    let pasteboard = UIPasteboard.general
    
    var body: some View {
        VStack {
            Counter(width: 150.0, height: 150.0, date: date)
                .padding(.bottom)
            
            Text(otpEntry.generateCode(date: date))
                .font(.system(.largeTitle, design: .monospaced))
                .padding(.bottom)
                .onTapGesture(count: 1) {
                    pasteboard.string = otpEntry.generateCode(date: date)
                }
            
            Text(otpEntry.issuer)
            
            Text(otpEntry.accountname)
                .opacity(0.6)
        }
    }
}

struct OTPDetail_Previews: PreviewProvider {
    static var previews: some View {
        OTPDetail(otpEntry: otpEntries[0], date: Date())
    }
}
