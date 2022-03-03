//
//  OTPList.swift
//  MFA
//
//  Created by Daniel Kelly on 2/20/22.
//

import SwiftUI

struct OTPList: View {
    @State private var showSheet = false
    @State private var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let otpEntries: [OTPEntry]
    
    var body: some View {
        NavigationView {
            VStack {
                if otpEntries.isEmpty {
                    Text("No codes to display")
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Counter(width: 50.0, height: 50.0, date: currentDate)
                        .padding(.bottom)
                    
                    List(otpEntries, id: \.id) { otpEntry in
                        NavigationLink {
                            OTPDetail(otpEntry: otpEntry, date: currentDate)
                        } label: {
                            OTPRow(otpEntry: otpEntry, date: currentDate)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onReceive(timer) { input in
                        currentDate = input
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showSheet) {
                        QRCodeScanner()
                    }
                }
            }
        }
    }
}

struct OTPList_Previews: PreviewProvider {
    static var previews: some View {
        OTPList(otpEntries: [])
        
        OTPList(otpEntries: [])
            .environment(\.colorScheme, .dark)
        
        OTPList(otpEntries: otpEntries)
        
        OTPList(otpEntries: otpEntries)
            .environment(\.colorScheme, .dark)
    }
}
