//
//  OTPRow.swift
//  MFA
//
//  Created by Daniel Kelly on 2/19/22.
//

import SwiftUI
import SwiftOTP

struct OTPRow: View {
    @EnvironmentObject var modelData: ModelData
    var otpEntry: OTPEntry
    
    var otpIndex: Int {
        modelData.otpEntries.firstIndex(where: { $0.id == otpEntry.id })!
    }
    
    var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(otpEntry.issuer)

                Text(otpEntry.accountname)
                    .opacity(0.6)
            }
            .lineLimit(1)
            
            Text(otpEntry.generateCode(date: date))
                .font(.system(.title, design: .monospaced))
                .fontWeight(.semibold)
        }
    }
}

struct OTPRow_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        OTPRow(otpEntry: modelData.otpEntries[0], date: Date())
            .environmentObject(ModelData())
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
