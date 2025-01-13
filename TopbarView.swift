//
//  TopbarView.swift
//  ArabicKeyboard
//
//  Created by Maryam Amer Bin Siddique on 01/07/1446 AH.
//

import SwiftUI

struct TopBarView: View { // Make TopBarView global
    @State var proxy: UITextDocumentProxy
    @Binding var predictions: [String]
    @Binding var showClipboard: Bool
    @Binding var showClipboardKeys: Bool
    
    @State private var context: String = ""
    @State private var timer: Timer? = nil
    
    var body: some View {
        HStack {
            // Left Prediction
            Button(predictions[0]) {
                proxy.insertText(predictions[0] + " ")
            }
            .frame(maxWidth: .infinity, maxHeight: 46)
            .foregroundStyle(.black)
            .font(.system(size: 25))
            
            Divider()
                .frame(height: 30)
                .background(Color(.systemGray3))
            // Clipboard Button
            Button(action: {
                showClipboardKeys = true
            }) {
                Image(systemName: "list.clipboard")
                    .font(.system(size: 30))
                    .frame(width: 56, height: 55)
                    .background(Color(.systemGray2))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
            }
            Divider()
                .frame(height: 30)
                .background(Color(.systemGray3))
            // Right Prediction
            Button(predictions[1]) {
                proxy.insertText(predictions[1] + " ")
            }
            .frame(maxWidth: .infinity, maxHeight: 46)
            .foregroundStyle(.black)
            .font(.system(size: 25))
        }
        .padding(.horizontal)
        .padding(.top, 35)
        .padding(.bottom, -1000)
    }
}
