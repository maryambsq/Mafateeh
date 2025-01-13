//
//  NumbersPage.swift
//  EnglishKeyboardView
//
//  Created by Maryam Amer Bin Siddique on 29/06/1446 AH.
//

import SwiftUI

struct NumbersPage: View {
    var proxy: UITextDocumentProxy
    @Binding var showNumbersPage: Bool

    var body: some View {
        VStack(spacing: 10) {
            // Row 1: Numbers Group (0-9)
            Button(action: {
                proxy.insertText("1234567890")
            }) {
                Text("1 2 3 4 5 6 7 8 9 0")
                    .frame(maxWidth: .infinity, minHeight: 72)
                    .background(Color.white)
                    .cornerRadius(8)
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }

            // Row 2: Symbols Group 1 (- / : ; ( ) $)
            Button(action: {
                proxy.insertText("-/:;()$")
            }) {
                Text("- / : ; ( ) $")
                    .frame(maxWidth: .infinity, minHeight: 72)
                    .background(Color.white)
                    .cornerRadius(8)
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }

            // Row 3: Symbols Group 2 (& @ " . , ? !)
            Button(action: {
                proxy.insertText("&@“.,?!")
            }) {
                Text("& @ “ . , ? !")
                    .frame(maxWidth: .infinity, minHeight: 72)
                    .background(Color.white)
                    .cornerRadius(8)
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }

            // Bottom Row: Navigation and Controls
            HStack(spacing: 8) {
                // ABC Button
                Button("ABC") {
                    showNumbersPage = false // Return to main page
                }
                .frame(width: 88, height: 72)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .font(.system(size: 24))
                .foregroundColor(.black)

                // Symbols Button
                Button("#+=") {
                    proxy.insertText("#+=")
                }
                .frame(width: 88, height: 72)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .font(.system(size: 24))
                .foregroundColor(.black)

                Spacer()

                // Backspace Button
                Button(action: {
                    proxy.deleteBackward()
                }) {
                    Image(systemName: "delete.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.black)
                }
                .frame(width: 88, height: 72)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)

            // Bottom Actions Row: Emoji, Space, Return
            HStack(spacing: 8) {
                // Emoji Button
                Button(action: {
                    // Placeholder for emoji action
                }) {
                    Image(systemName: "face.smiling")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.black)
                }
                .frame(width: 72, height: 72)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

                // Space Bar
                Button("Space") {
                    proxy.insertText(" ")
                }
                .frame(maxWidth: .infinity, maxHeight: 72)
                .background(Color.white)
                .cornerRadius(8)
                .font(.system(size: 24))
                .foregroundColor(.black)

                // Return Key
                Button("Return") {
                    proxy.insertText("\n")
                }
                .frame(width: 128, height: 72)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .font(.system(size: 24))
                .foregroundColor(.black)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.1))
    }
}
