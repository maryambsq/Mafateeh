//
//  ArabicNumbers.swift
//  ArabicKeyboard
//
//  Created by Maryam Amer Bin Siddique on 01/07/1446 AH.
//

//
//  ArabicNumbers.swift
//  EnlargedKeysArabic
//
//  Created by Maryam Amer Bin Siddique on 30/06/1446 AH.
//

import SwiftUI

struct ArabicNumbers: View {
    @State var proxy: UITextDocumentProxy
    @Binding var showKeyboardview: Bool // <-- Fixed binding
    @State private var enlargedKeys: [String] = [] // Enlarged keys
    @State private var showEnlargedKeys = false // Toggle view state
    @State private var showArabicKeyboard = false // NEW STATE to go back to Arabic Keyboard
    @Binding var showArabicSymbols: Bool // Controls navigation to Arabic Symbols Keyboard

    // Grouped Keys (Lowercase)
    let groupNumber: [(String, [String])] = [
        ("١     ٢     ٣     ٤     ٥                        ٦     ٧    ٨     ٩     ٠", ["١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩", "٠"]),
    ]

    let groupSymbol: [(String, [String])] = [
        ("-  /  :  ;  (   )  $", ["-", "/", ":", ";", "(", ")", "$"])
    ]

    let groupSymbo2: [(String, [String])] = [
        ("&   @   “   .   ,   ؟   !", ["&", "@", "“", ".", ",", "؟", "!"])
    ]

    var body: some View {
        if showArabicKeyboard { // If Arabic keyboard button is pressed
            Keyboardview(proxy: proxy, showKeyboardview: $showArabicKeyboard, showArabicKeyboard: $showArabicKeyboard, showArabicSymbols: $showArabicSymbols) // Switch back to Arabic Keyboard
        } else if showArabicSymbols {
            ArabicSymbols(proxy: proxy, showArabicSymbols: $showArabicSymbols)
        } else if showEnlargedKeys {
            // Render the Enlarged Keys Page
            EnlargedKeysView(proxy: proxy, enlargedKeys: $enlargedKeys, showEnlargedKeys: $showEnlargedKeys)

        } else {
            VStack(spacing: 10) {
                VStack(spacing: 10) {
                    // Alphabetic Keyboard View
                    AlphabeticKeyboardView(
                        proxy: proxy,
                        groupNumber: groupNumber,
                        groupSymbol: groupSymbol,
                        groupSymbo2: groupSymbo2,
                        showEnlargedKeys: $showEnlargedKeys,
                        enlargedKeys: $enlargedKeys,
                        showKeyboardview: $showKeyboardview, showArabicKeyboard: $showArabicKeyboard,
                        showArabicSymbols: $showArabicSymbols // Pass binding here
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: Alphabetic Keyboard View
struct AlphabeticKeyboardView: View {
    var proxy: UITextDocumentProxy
    let groupNumber: [(String, [String])]
    let groupSymbol: [(String, [String])]
    let groupSymbo2: [(String, [String])]

    @Binding var showEnlargedKeys: Bool
    @Binding var enlargedKeys: [String]
    @Binding var showKeyboardview: Bool // Fixed Binding
    @Binding var showArabicKeyboard: Bool
    @Binding var showArabicSymbols: Bool// NEW STATE to go back to Arabic Keyboard

    var body: some View {
        VStack(spacing: 10) {
            VStack {
                // Numbers Group
                HStack {
                    ForEach(groupNumber, id: \.0) { key, keys in
                        Button(action: {
                            enlargedKeys = keys
                            showEnlargedKeys = true
                        }) {
                            Text(key)
                                .frame(width: 245, height: 108)
                                .font(.system(size: 30))
                                .background(Color(.white))
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                        }
                    }


                // Symbols Group 1
                    ForEach(groupSymbol, id: \.0) { key, keys in
                        Button(action: {
                            enlargedKeys = keys
                            showEnlargedKeys = true
                        }) {
                            Text(key)
                                .frame(width: 104, height: 108)
                                .font(.system(size: 30))
                                .background(Color(.white))
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                        }
                    }
                }

                // Symbols Group 2
                HStack {
                    ForEach(groupSymbo2, id: \.0) { key, keys in
                        Button(action: {
                            enlargedKeys = keys
                            showEnlargedKeys = true
                        }) {
                            Text(key)
                                .frame(width: 290, height: 61)
                                .font(.system(size: 30))
                                .background(Color(.white))
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                        }
                    }
                }

                // Navigation Buttons
                HStack {
                    // Switch back to Arabic Keyboard
                    Button("أ  ب  ج") {
                        showArabicKeyboard = true // Activate Arabic Keyboard
                    }
                    .frame(width: 125, height: 51)
                    .background(Color(.systemGray2))
                    .font(.system(size: 25))
                    .cornerRadius(8)
                    .foregroundStyle(.black)

                    // Symbols Button
                    Button("#+=") {
                        showArabicSymbols = true // Navigate to ArabicSymbols
                        showKeyboardview = false // Activate Numbers Keyboard
                    }
                    .frame(width: 67, height: 51)
                    .background(Color(.systemGray2))
                    .font(.system(size: 20))
                    .cornerRadius(8)
                    .foregroundStyle(.black)

                    // Backspace
                    Button(action: {
                        proxy.deleteBackward()
                    }) {
                        Image(systemName: "delete.left")
                            .frame(width: 75, height: 51)
                            .background(Color(.systemGray2))
                            .font(.system(size: 30))
                            .cornerRadius(8)
                            .foregroundStyle(.black)
                    }
                    .padding(.trailing, -17)
                }
                .padding(.leading, 70)
            }

            // Bottom Row
            HStack {
                Button(action: {}) {
                    Image(systemName: "face.smiling")
                        .frame(width: 56, height: 50)
                        .background(Color(.systemGray2))
                        .font(.system(size: 25))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        .padding(.leading, -5)
                }

                Button("مسافة") {
                    proxy.insertText(" ")
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color(.white))
                .cornerRadius(8)
                .foregroundStyle(.black)

                Button(action: {
                    proxy.insertText("\n")
                }) {
                    Image(systemName: "return.right")
                        .font(.system(size: 25))
                        .foregroundStyle(.black)
                }
                .frame(width: 111, height: 50)
                .background(Color(.systemGray2))
                .cornerRadius(8)
                .padding(.trailing, -5)
            }
            .padding(.top, -1)
        }
        .padding(.bottom, -120)
    }
}
struct EnlargedKeysView: View {
    var proxy: UITextDocumentProxy
    @Binding var enlargedKeys: [String]
    @Binding var showEnlargedKeys: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // السطر الأول: 1، 2، 3، 4
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    ForEach(enlargedKeys.prefix(4), id: \.self) { key in
                        Button(action: {
                            proxy.insertText(key)
                        }) {
                            Text(key)
                                .frame(width: 75, height: 75)
                                .background(Color.white)
                                .cornerRadius(8)
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                        }
                    }
                }
                
                // السطر الثاني: 5، 6، 7
                HStack(spacing: 10) {
                    ForEach(enlargedKeys[4..<7], id: \.self) { key in
                        Button(action: {
                            proxy.insertText(key)
                        }) {
                            Text(key)
                                .frame(width: 75, height: 75)
                                .background(Color.white)
                                .cornerRadius(8)
                                .font(.system(size: 30))
                                .foregroundColor(.black)
                        }
                    }
                }
                
                // السطر الثالث: 8، 9، 0
                HStack(spacing: 10) {
                    ForEach(enlargedKeys[7...], id: \.self) { key in
                        Button(action: {
                            proxy.insertText(key)
                        }) {
                            Text(key)
                                .frame(width: 75, height: 75)
                                .background(Color.white)
                                .cornerRadius(8)
                                .font(.system(size: 30))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding(.leading)
            .padding(.bottom, -30)
            
            VStack (alignment: .trailing) {
                // زر الرجوع
                Button(action: {
                    showEnlargedKeys = false
                }) {
                    Image(systemName: "chevron.forward")
                        .frame(width: 61, height: 55)
                        .background(Color(.systemGray2))
                        .font(.system(size: 30))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
                .padding(.top, -85)
                
                // زر الحذف
                Button(action: {
                    proxy.deleteBackward()
                }) {
                    Image(systemName: "delete.left")
                        .frame(width: 72, height: 46)
                        .background(Color(.systemGray2))
                        .font(.system(size: 25))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
                .padding(.top, -35)
            }
            .padding(.leading, 310)

            // Space Bar Row
            HStack(alignment: .bottom, spacing: 10) {
                Button("مسافة") {
                    proxy.insertText(" ")
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color(.white))
                .cornerRadius(8)
                .foregroundStyle(.black)

                // Return Button
                Button(action: {
                    proxy.insertText("\n")
                }) {
                    Image(systemName: "return.right")
                        .font(.system(size: 25))
                        .foregroundStyle(.black)
                }
                .frame(width: 111, height: 50)
                .background(Color(.systemGray2))
                .cornerRadius(8)
                .padding(.trailing, -5)
           }
            .padding(.horizontal)
//            .padding(.bottom, -1000)
        }
        .padding(.bottom, -100)
    }
}
