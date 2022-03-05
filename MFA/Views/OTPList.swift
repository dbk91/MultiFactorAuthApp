//
//  OTPList.swift
//  MFA
//
//  Created by Daniel Kelly on 2/20/22.
//

import SwiftUI

struct OTPList: View {
    @EnvironmentObject var modelData: ModelData
    
    @State private var showSheet = false
    @State private var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var searchText = ""
    
    var searchResults: [OTPEntry] {
        if searchText.isEmpty {
            return modelData.otpEntries
        }
        
        return modelData.otpEntries.filter {
            $0.issuer.contains(searchText) || $0.accountname.contains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            Counter(width: 50.0, height: 50.0, date: currentDate)
                .padding(.bottom)
            NavigationView {
                VStack {
                    if modelData.otpEntries.isEmpty {
                        Text("No codes to display")
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        
                        List {
                            ForEach(searchResults) { otpEntry in
                                NavigationLink {
                                    OTPDetail(otpEntry: otpEntry, date: currentDate)
                                } label: {
                                    OTPRow(otpEntry: otpEntry, date: currentDate)
                                }
                            }
                            .onDelete { indexSet in
                                modelData.otpEntries.remove(atOffsets: indexSet)
                            }
                        }
                        .onReceive(timer) { input in
                            currentDate = input
                        }
                        .listStyle(.plain)
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
}

struct OTPList_Previews: PreviewProvider {
    static var previews: some View {
        OTPList()
            .environmentObject(ModelData())
        
        OTPList()
            .environment(\.colorScheme, .dark)
            .environmentObject(ModelData())
        
        OTPList()
            .environmentObject(ModelData())
        
        OTPList()
            .environment(\.colorScheme, .dark)
            .environmentObject(ModelData())
    }
}
