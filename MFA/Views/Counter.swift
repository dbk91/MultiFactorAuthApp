//
//  Counter.swift
//  MFA
//
//  Created by Daniel Kelly on 2/27/22.
//

import SwiftUI

struct Counter: View {
    var width: CGFloat
    var height: CGFloat
    var date: Date
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.purple, lineWidth: 4.0)
                .frame(width: width, height: height)

            Text("\(30 - (Int(date.timeIntervalSince1970) % 30))")
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct Counter_Previews: PreviewProvider {
    static var previews: some View {
        Counter(width: 50.0, height: 50.0, date: Date())
            .previewLayout(.fixed(width: 60, height: 60))
    }
}
