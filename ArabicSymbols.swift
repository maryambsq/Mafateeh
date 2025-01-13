//
//  ArabicSymbols.swift
//  ArabicKeyboard
//
//  Created by Maryam Amer Bin Siddique on 01/07/1446 AH.
//

import SwiftUI

struct ArabicSymbols: View {
    @State var proxy: UITextDocumentProxy
    @State private var enlargedKeys: [String] = [] // Enlarged keys
    @State private var showEnlargedKeys = false // Toggle view state
    @Binding var showArabicSymbols: Bool
    @State private var showArabicNumbers = false
    @State private var showArabicKeyboard = false

    // Grouped Keys (Lowercase)
    let group1Lower: [(String, [String])] = [
        ("[  ]  { }                    _  |  ", ["[", "]", "{", "}", "ـ", "|"]),
        ("#  %  ^  ~                <  >  €", ["#", "%", "^", "~", "<", ">", "€"]),
        ("*  +  =                    £  ¥  •", ["*", "+", "=", "£", "¥", "•"])
    ]
    
    var body: some View {
        VStack(spacing: 5) {
            // Enlarged Keys View
            if showEnlargedKeys {
                VStack {
                    ZStack {
                        if enlargedKeys.count == 6 {
                            templateOne(keys: enlargedKeys, proxy: proxy, showEnlargedKeys: $showEnlargedKeys)
                        } else {
                            templateTwo(keys: enlargedKeys, proxy: proxy, showEnlargedKeys: $showEnlargedKeys)
                        }
                        VStack {
                            // Back Button
                            Button(action:  {
                                showEnlargedKeys = false
                            }) {
                                Image(systemName: "arrowshape.turn.up.right")
                                    .frame(width: 61, height: 55)
                                    .background(Color(.systemGray2))
                                    .font(.system(size: 30))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.top)
                                    .padding(.leading)
                            }
                            // Backspace
                            Button(action: {
                                proxy.deleteBackward()
                            }) {
                                Image(systemName: "delete.left")
                                    .frame(width: 72, height: 46)
                                    .background(Color(.systemGray2))
                                    .font(.system(size: 25))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding(.top, 100)
                        .padding(.leading, 290)
                    }
                    HStack {
                        // Space Bar
                        Button("مسافة") {
                            proxy.insertText(" ")
                        }
                        .frame(maxWidth: .infinity, maxHeight: 56)
                        .background(Color(.white))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        
                        // Return Key
                        Button("Return") {
                            proxy.insertText("\n")
                        }
                        .frame(width: 111, height: 55)
                        .background(Color(.systemGray2))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        .padding(.trailing, -5)
                    }
                    .padding(.horizontal)
                }
            } else if showArabicKeyboard { // If Arabic keyboard button is pressed
                Keyboardview(proxy: proxy, showKeyboardview: $showArabicKeyboard, showArabicKeyboard: $showArabicKeyboard, showArabicSymbols: $showArabicSymbols) // Switch back to Arabic Keyboard
            } else if showArabicSymbols {
                ArabicSymbols(proxy: proxy, showArabicSymbols: $showArabicSymbols)
            } else if showEnlargedKeys {
                // Render the Enlarged Keys Page
                EnlargedKeysView(proxy: proxy, enlargedKeys: $enlargedKeys, showEnlargedKeys: $showEnlargedKeys)

//            } else if {
//                VStack(spacing: 10) {
//                    VStack(spacing: 10) {
//                        // Alphabetic Keyboard View
//                        AlphabeticKeyboardView(
//                            proxy: proxy,
////                            groupNumber: groupNumber,
////                            groupSymbol: groupSymbol,
////                            groupSymbo2: groupSymbo2,
//                            showEnlargedKeys: $showEnlargedKeys,
//                            enlargedKeys: $enlargedKeys,
////                            showKeyboardview: $showKeyboardview, showArabicKeyboard: $showArabicKeyboard,
//                            showArabicSymbols: $showArabicSymbols // Pass binding here
//                        )
//                    }
//                    .padding(.horizontal)
//                }
            } else {
                // Main Keyboard Layout
                VStack(spacing: 10) {
                    // Grouped Keys (Rows)
                    let group1 = group1Lower
                    
                    VStack {
                        HStack {
                            ForEach(group1, id: \.0) { key, keys in
                                Button(action: {
                                    enlargedKeys = keys // Preserves the exact key order
                                    showEnlargedKeys = true
                                }) {
                                    Text(key) // Displays the group label
                                        .frame(width: 119, height: 169) // Set the size of the outer button
                                        .font(.system(size: 30))
                                        .background(Color(.white))
                                        .cornerRadius(8)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                    
                    // Bottom Row Buttons (Aligned to the right)
                    HStack(spacing: 5) {  // Adjusted the spacing to make the buttons closer
                        // Numbers Keyboard
                        Button("أ ب ج") {
                            showArabicKeyboard = true // Navigate to ArabicKeyboardView
                            showArabicSymbols = false
                        }
                        .frame(width: 127, height: 46)
                        .background(Color(.systemGray2))
                        .font(.system(size: 20))
                        .cornerRadius(8)
                        .foregroundStyle(.black)

                        // Symbols Keyboard
                        Button("١ ٢ ٣") {
                            showArabicNumbers = true // Navigate to ArabicNumbers
                            showArabicSymbols = false
                        }
                        .frame(width: 67, height: 46)
                        .background(Color(.systemGray2))
                        .font(.system(size: 20))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        
                        // Backspace
                        Button(action: {
                            proxy.deleteBackward()
                        }) {
                            Image(systemName: "delete.left")
                                .frame(width: 72, height: 46)
                                .background(Color(.systemGray2))
                                .font(.system(size: 25))
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing) // Ensure they are aligned to the right
                    
                    // Emoji, Space, Return
                    HStack {
                        // Emoji Button
                        Button(action: {
                            // Placeholder for emoji action
                        }) {
                            Image(systemName: "face.smiling")
                                .frame(width: 56, height: 55)
                                .background(Color(.systemGray2))
                                .font(.system(size: 25))
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                                .padding(.leading, -5)
                        }
                        
                        // Space Bar
                        Button("Space") {
                            proxy.insertText(" ")
                        }
                        .frame(maxWidth: .infinity, maxHeight: 56)
                        .background(Color(.white))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        
                        // Return Key
                        Button("Return") {
                            proxy.insertText("\n")
                        }
                        .frame(width: 111, height: 55)
                        .background(Color(.systemGray2))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        .padding(.trailing, -5)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // Enlarged Keys Templates
    func templateOne(keys: [String], proxy: UITextDocumentProxy, showEnlargedKeys: Binding<Bool>) -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                ForEach(keys.prefix(3), id: \.self) { key in
                    Button(key) {
                        proxy.insertText(key)
                    }
                    .frame(width: 78, height: 95) // Set the size of the outer button for enlarged keys
                    .background(Color.white)
                    .font(.system(size: 45))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                }
            }
            HStack(spacing: 20) {
                ForEach(keys.suffix(3), id: \.self) { key in
                    Button(key) {
                        proxy.insertText(key)
                    }
                    .frame(width: 78, height: 95) // Set the size of the outer button for enlarged keys
                    .background(Color.white)
                    .font(.system(size: 45))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                }
            }
            .padding(.leading, -100)
        }
    }

    func templateTwo(keys: [String], proxy: UITextDocumentProxy, showEnlargedKeys: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                ForEach(keys.prefix(4), id: \.self) { key in
                    Button(key) {
                        proxy.insertText(key)
                    }
                    .frame(width: 78, height: 95) // Set the size of the outer button for enlarged keys
                    .background(Color.white)
                    .font(.system(size: 45))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                }
            }
            HStack(spacing: 20)  {
                ForEach(keys.suffix(3), id: \.self) { key in
                    Button(key) {
                        proxy.insertText(key)
                    }
                    .frame(width: 78, height: 95) // Set the size of the outer button for enlarged keys
                    .background(Color.white)
                    .font(.system(size: 45))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                }
            }
        }
        .padding(.bottom, 20)
    }
}
