////
//  MainEnglishKeyboard.swift
//  EnglishKeyboardView
//
//  Created by Maryam Amer Bin Siddique on 24/06/1446 AH.
//

import SwiftUI
import SwiftData

struct MainEnglishKeyboard: View {
    @State var proxy: UITextDocumentProxy
    @State private var enlargedKeys: [String] = [] // Enlarged keys
    @State private var showEnlargedKeys = false // Toggle view state
    @State private var isUppercase = false // Track Shift state
    @State private var predictions: [String] = ["", ""]
    @Environment(\.modelContext) private var modelContext
    @Query private var savedPhrases: [Phrase] // Fetch saved phrases
    @State private var showClipboard = false // Track whether clipboard view is open
    @State private var showClipboardKeys = false // New toggle for clipboard
   
    
    @State private var showNumbersKeyboard = false // New state to show NumbersKeyboardView


    
    // Grouped Keys (Lowercase)
    let group1Lower: [(String, [String])] = [
        ("q  w  e                    a  s  d", ["q", "w", "e", "a", "s", "d"]),
        ("r  t  y  u                 f  g  h", ["r", "t", "y", "u", "f", "g", "h"]),
        ("i  o  p                    j  k  l", ["i", "o", "p", "j", "k", "l"])
    ]

    let group2Lower: [(String, [String])] = [
        ("z  x  c  v  b  n  m", ["z", "x", "c", "v", "b", "n", "m"])
    ]

    // Grouped Keys (Uppercase)
    let group1Upper: [(String, [String])] = [
        ("Q  W  E                    A  S  D", ["Q", "W", "E", "A", "S", "D"]),
        ("R T Y U                 F  G  H", ["R", "T", "Y", "U", "F", "G", "H"]),
        ("I  O  P                    J  K  L", ["I", "O", "P", "J", "K", "L"])
    ]

    let group2Upper: [(String, [String])] = [
        ("Z  X  C  V  B  N  M", ["Z", "X", "C", "V", "B", "N", "M"])
    ]
    
    var body: some View {
        VStack(spacing: 5) {
            // Conditionally show TopBarView only when ClipboardKeysView is NOT displayed
            if !showClipboardKeys {
                TopBarView(
                    proxy: proxy,
                    predictions: $predictions,
                    showClipboard: $showClipboard,
                    showClipboardKeys: $showClipboardKeys
                )
                .padding(.bottom)
            }
            // Call fetchPhrases when keyboard loads
            }
            // Check if ClipboardKeysView should be shown
            if showClipboardKeys {
                // Enlarged clipboard layout
                ClipboardKeysView(
                    proxy: proxy,
                    showClipboardKeys: $showClipboardKeys
                )
            } else if showEnlargedKeys {
                // Enlarged keys layout
                VStack {
                    ZStack {
                        if enlargedKeys.count == 6 {
                            templateOne(
                                keys: enlargedKeys,
                                proxy: proxy,
                                showEnlargedKeys: $showEnlargedKeys
                            )
                        } else {
                            templateTwo(
                                keys: enlargedKeys,
                                proxy: proxy,
                                showEnlargedKeys: $showEnlargedKeys
                            )
                        }

                        VStack {
                            // Back Button
                            Button(action:  {
                                showEnlargedKeys = false
                            }) {
                                Image(systemName: "chevron.forward")
                                    .frame(width: 61, height: 55)
                                    .background(Color(.systemGray2))
                                    .font(.system(size: 30))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.trailing, 5)
                                    .padding(.top)
                                    .padding(.leading)
                            }

                            // Backspace Button
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
                        .padding(.top, 104)
                        .padding(.leading, 296)
                    }
                    
                    // Bottom buttons for space, shift, return
                    HStack {
                        // Shift Button
                        Button(action: {
                            isUppercase.toggle()
                        }) {
                            Image(systemName: isUppercase ? "shift.fill" : "shift")
                                .font(.system(size: 30))
                                .frame(width: 56, height: 55)
                                .background(isUppercase ? Color(.white) : Color(.systemGray2))
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                                .padding(.leading, -5)
                        }

                        // Space Bar
                        Button("space") {
                            proxy.insertText(" ")
                        }
                        .frame(maxWidth: .infinity, maxHeight: 56)
                        .background(Color(.white))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        
                        // Return Key
                        Button("return") {
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
                
            } else {
                // Main Keyboard Layout
                VStack(spacing: 10) {
                    let group1 = isUppercase ? group1Upper : group1Lower
                    let group2 = isUppercase ? group2Upper : group2Lower
                    
                    VStack {
                        HStack {
                            ForEach(group1, id: \.0) { key, keys in
                                Button(action: {
                                    enlargedKeys = keys
                                    showEnlargedKeys = true
                                }) {
                                    Text(key)
                                        .frame(width: 119, height: 108)
                                        .font(.system(size: 30))
                                        .background(Color(.white))
                                        .cornerRadius(8)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        
                        HStack {
                            // Shift Button
                            Button(action: {
                                isUppercase.toggle()
                            }) {
                                Image(systemName: isUppercase ? "shift.fill" : "shift")
                                    .font(.system(size: 30))
                                    .frame(width: 55.5, height: 108)
                                    .background(isUppercase ? Color(.white) : Color(.systemGray2))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.trailing, 10)
                            }
                            VStack {
                                ForEach(group2, id: \.0) { key, keys in
                                    Button(action: {
                                        enlargedKeys = keys
                                        showEnlargedKeys = true
                                    }) {
                                        Text(key)
                                            .frame(width: 290, height: 61)
                                            .background(Color(.white))
                                            .font(.system(size: 30))
                                            .cornerRadius(8)
                                            .foregroundStyle(.black)
                                    }
                                }

                                HStack {
                                    Button("1 2 3") {
                                        showNumbersKeyboard = true
                                    }
                                    .frame(width: 125, height: 46)
                                    .background(Color(.systemGray2))
                                    .font(.system(size: 20))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.trailing, 10)

                                    Button("#+=") {
                                        proxy.insertText("#+=")
                                    }
                                    .frame(width: 67, height: 46)
                                    .background(Color(.systemGray2))
                                    .font(.system(size: 20))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.trailing, 5)

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
                            }
                        }
                    }
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "face.smiling")
                                .frame(width: 56, height: 55)
                                .background(Color(.systemGray2))
                                .font(.system(size: 25))
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                                .padding(.leading, -5)
                        }
                        
                        Button("space") {
                            proxy.insertText(" ")
                        }
                        .frame(maxWidth: .infinity, maxHeight: 56)
                        .background(Color(.white))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        
                        Button("return") {
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
    // Top Bar View
    struct TopBarView: View {
        @State var proxy: UITextDocumentProxy
        @Binding var predictions: [String]
        @Binding var showClipboard: Bool
        @Binding var showClipboardKeys: Bool
        
        @State private var context: String = ""
        @State private var timer: Timer? = nil // Timer to monitor input changes

        var body: some View {
            HStack {
                // Left Predictive Text
                Button(predictions[0]) {
                                proxy.insertText(predictions[0] + " ")
                }
                .frame(maxWidth: .infinity, maxHeight: 46)
                .foregroundStyle(.black)
                .font(.system(size: 25))
                
                // Divider Line
                Divider()
                    .frame(height: 30)
                    .background(Color(.systemGray3))

                // Clipboard Button
                Button(action: {
                    showClipboardKeys = true // Show enlarged clipboard layout
                }) {
                    Image(systemName: "list.clipboard")
                        .font(.system(size: 30))
                        .frame(width: 56, height: 55)
                        .background(Color(.systemGray2))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                }
//                .sheet(isPresented: $showClipboard) {
//                    ClipboardView(proxy: proxy) // Show ClipboardView
//                }
//                .padding(.horizontal)
                
                // Divider Line
                Divider()
                    .frame(height: 30)
                    .background(Color(.systemGray3))

                // Right Predictive Text
                Button(predictions[1]) {
                    proxy.insertText(predictions[1] + " ")
                }
                .frame(maxWidth: .infinity, maxHeight: 46)
                .foregroundStyle(.black)
                .font(.system(size: 25))
            }
            .padding(.horizontal)
            .padding(.top)
            .onAppear {
                startMonitoringContext() // Start context monitoring when loaded
            }
        }
        // Prediction Logic
        func updatePredictions(from context: String?) {
            guard let context = context, !context.isEmpty else {
                predictions = ["I", "We"] // Default predictions
                return
            }

            let words = context.split(separator: " ")
            let lastWord = words.last?.lowercased() ?? ""

            // Example static predictions based on the last word
            switch lastWord {
            case "a":
                predictions = ["and", "about"]
            case "b":
                predictions = ["before", "bye"]
            case "c":
                predictions = ["card", "cold"]
            case "d":
                predictions = ["do", "door"]
            case "i":
                predictions = ["I'm", "is"]
            case "h":
                predictions = ["hi", "hello"]
            case "he":
                predictions = ["hey", "hello"]
            case "you":
                predictions = ["are", "will"]
            case "we":
                predictions = ["are", "can"]
            case "he ":
                predictions = ["is", "was"]
            case "she":
                predictions = ["is", "was"]
            case "it":
                predictions = ["is", "will"]
            default:
                predictions = ["I", "The"]
            }
        }
        
        // Monitor Context Changes
        func startMonitoringContext() {
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                let currentContext = proxy.documentContextBeforeInput ?? ""
                if currentContext != context { // Check if context has changed
                    context = currentContext // Update context
                    updatePredictions(from: context) // Update predictions
                }
            }
        }

    }
    
//    struct ClipboardView: View {
//        @Environment(\.modelContext) private var modelContext
//        @Query private var savedPhrases: [Phrase]
//        var proxy: UITextDocumentProxy
//        
//        var body: some View {
//            VStack {
//                Text("My Clipboard")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                    .padding(.top)
//                
//                ScrollView {
//                    VStack(spacing: 10) {
//                        ForEach(savedPhrases) { phrase in
//                            Button(action: {
//                                proxy.insertText(phrase.content + " ") // Insert phrase
//                            }) {
//                                Text(phrase.content)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .padding()
//                            }
//                            .background(Color(.systemGray6))
//                            .cornerRadius(8)
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//    }
    
    struct ClipboardKeysView: View {
        @Environment(\.modelContext) private var modelContext // Access the shared database context
        @State private var savedPhrases: [Phrase] = [] // Use state to hold data locally
        
        var proxy: UITextDocumentProxy
        @Binding var showClipboardKeys: Bool // Toggle back to main view
        
        var body: some View {
            VStack {
                // Top Bar with Back Button
                HStack {
                    Button(action: {
                        showClipboardKeys = false // Go back to main keyboard
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .padding(.leading)
                            .padding(.top, 30)
                            .foregroundStyle(Color.black)
                        Text("Back")
                            .font(.system(size: 20))
                            .padding(.top, 30)
                            .foregroundStyle(Color.black)
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                
                // Display Saved Phrases
                TabView {
                    Text("+")
                        .frame(width: 150, height: 100)
                        .font(.system(size: 30))
                        .foregroundStyle(Color.black)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.leading, -180)
                        .padding(.top, -150)
                    ForEach(savedPhrases.chunked(into: 3), id: \.self) { chunk in
                        VStack(spacing: 10) {
                            ForEach(chunk) { phrase in
                                Button(action: {
                                    proxy.insertText(phrase.content + " ")
                                }) {
                                    Text(phrase.content)
                                        .frame(width: 150, height: 100)
                                        .background(Color.white)
                                        .font(.system(size: 25))
                                        .cornerRadius(8)
                                        .foregroundStyle(.black)
                                        .padding(5)
                                }
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 300) // Set height for pages
                .padding()
                ForEach(savedPhrases, id: \.self) { phrase in
                    Button(action: {
                        proxy.insertText(phrase.content + " ")
                    }) {
                        Text(phrase.content)
                            .frame(width: 150, height: 100)
                            .background(Color.white)
                            .font(.system(size: 25))
                            .cornerRadius(8)
                            .foregroundStyle(.black)
                            .padding(5)
                    }
                }
            }
            .onAppear {
                fetchPhrases()
            }
        
        }
        func fetchClipboardPhrases() {
            let fetchDescriptor = FetchDescriptor<Phrase>()
            do {
                savedPhrases = try modelContext.fetch(fetchDescriptor) // Fetch phrases
                print("Fetched phrases: \(savedPhrases)") // Debug log
            } catch {
                print("Failed to fetch phrases: \(error)") // Debug log
            }
        }
        func fetchPhrases() {
            // Fetch saved phrases from SwiftData model context
            let fetchDescriptor = FetchDescriptor<Phrase>() // Fetch all Phrase objects
            do {
                let phrases = try modelContext.fetch(fetchDescriptor)
                print("Fetched phrases: \(phrases)") // Debug output
            } catch {
                print("Failed to fetch phrases: \(error)") // Handle errors
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
                    .frame(width: 75, height: 95)
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
                    .frame(width: 75, height: 95)
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
                    .frame(width: 75, height: 95)
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
                    .frame(width: 75, height: 95)
                    .background(Color.white)
                    .font(.system(size: 45))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                }
            }
        }
        .padding(.bottom, 20)
    
    }
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}


struct NumbersKeyboardView: View {
    @State var proxy: UITextDocumentProxy
    @State private var enlargedKeys: [String] = [] // Enlarged keys
    @State private var showEnlargedKeys = false // Toggle view state

    // Grouped Keys (Lowercase)
    let groupNumber: [(String, [String])] = [
        ("1     2     3     4     5                        6     7    8     9     0", ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]),
    ]

    let groupSymbol: [(String, [String])] = [
        ("-  /  :  ;  (   )  $", ["-", "/", ":", ";", "(", ")", "$"])
    ]

    let groupSymbo2: [(String, [String])] = [
        ("&   @   “   .   ,   ?   !", ["&", "@", "“", ".", ",", "?", "!"])
    ]

    var body: some View {
        VStack(spacing: 10) {
            if showEnlargedKeys {
                // Enlarged Keys View
                EnlargedKeysView(proxy: proxy, enlargedKeys: $enlargedKeys, showEnlargedKeys: $showEnlargedKeys)
            } else {
                AlphabeticKeyboardView(
                    proxy: proxy,
                    groupNumber: groupNumber,
                    groupSymbol: groupSymbol,
                    groupSymbo2: groupSymbo2,
                    showEnlargedKeys: $showEnlargedKeys,
                    enlargedKeys: $enlargedKeys
                )
            }
        }
        .padding(.horizontal)
    }
}

struct AlphabeticKeyboardView: View {
    var proxy: UITextDocumentProxy
    let groupNumber: [(String, [String])]
    let groupSymbol: [(String, [String])]
    let groupSymbo2: [(String, [String])]

    @Binding var showEnlargedKeys: Bool
    @Binding var enlargedKeys: [String]

    var body: some View {
        VStack(spacing: 10) {
            let group1 = groupNumber
            let group2 = groupSymbol
            let group3 = groupSymbo2

            VStack {
                HStack {
                    ForEach(group1, id: \.0) { key, keys in
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

                        ForEach(group2, id: \.0) { key, keys in
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
                }

                ForEach(group3, id: \.0) { key, keys in
                    Button(action: {
                        enlargedKeys = keys
                        showEnlargedKeys = true // Show enlarged keyboard for groupSymbo2
                    }) {
                        Text(key)
                            .frame(width: 290, height: 61)
                            .font(.system(size: 30))
                            .background(Color(.white))
                            .cornerRadius(8)
                            .foregroundStyle(.black)
                    }
                }

                HStack {
                    // Numbers Keyboard
                    Button("ABC") {
                        // Removed the transition to NumbersPage
                    }
                    .frame(width: 125, height: 46)
                    .background(Color(.systemGray2))
                    .font(.system(size: 20))
                    .cornerRadius(8)
                    .foregroundStyle(.black)

                    // Symbols Keyboard
                    Button("#+=") {
                        proxy.insertText("#+=")
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
                .padding(.leading, 70)
            }

            // Bottom Row
            HStack {
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

                Button("space") {
                    proxy.insertText(" ")
                }
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color(.white))
                .cornerRadius(8)
                .foregroundStyle(.black)

                Button("return") {
                    proxy.insertText("\n")
                }
                .frame(width: 112, height: 55)
                .background(Color(.systemGray2))
                .cornerRadius(8)
                .foregroundStyle(.black)
            }
        }
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
                            showEnlargedKeys = false
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
                            showEnlargedKeys = false
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
                
                // السطر الثالث: 8، 9، 0
                HStack(spacing: 10) {
                    ForEach(enlargedKeys[7...], id: \.self) { key in
                        Button(action: {
                            proxy.insertText(key)
                            showEnlargedKeys = false
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
            }
            
            VStack (alignment: .center) {
                // زر الرجوع
                Button(action: {
                    showEnlargedKeys = false
                }) {
                    Image(systemName: "arrowshape.turn.up.right")
                        .frame(width: 61, height: 55)
                        .background(Color(.systemGray2))
                        .font(.system(size: 30))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
                .padding(.leading, 280)
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
                .padding(.leading, 280)
                .padding(.top, -35)
            }
            // Space Bar Row
            HStack(spacing: 10) {
                Button("space") {
                    proxy.insertText(" ")
                }
                .frame(width: 238, height: 56)
                .background(Color(.white))
                .cornerRadius(8)
                .foregroundStyle(.black)

                // Return Button
                Button("return") {
                    proxy.insertText("\n")
                }
                .frame(width: 112, height: 55)
                .background(Color(.systemGray2))
                .cornerRadius(8)
                .foregroundStyle(.black)
                .padding(.trailing, -5)
           
           }
            .padding(.bottom)
        }
        .padding(.top)
        .padding(.leading)
    }
}
