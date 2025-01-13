//
//  ArabicKeyboardView.swift
//  EnlargedKeysArabic
//
//  Created by Maryam Amer Bin Siddique on 30/06/1446 AH.
//

import SwiftUI
import SwiftData

@Model // This makes it a SwiftData model
class Phrase: Identifiable {
    @Attribute(.unique) var id: UUID // Unique identifier
    var content: String // The phrase content
    
    init(content: String) {
        self.id = UUID()
        self.content = content
    }
}

struct Keyboardview: View {
    @State var proxy: UITextDocumentProxy
    @Binding var showKeyboardview: Bool // <-- Correct binding
    @State private var enlargedKeys: [String] = [] // Enlarged keys
    @State private var showEnlargedKeys = false // Toggle view state
    @State private var showClipboardKeys = false
    @Query private var savedPhrases: [Phrase]
    @State private var predictions: [String] = ["" , ""]
    @Environment(\.modelContext) private var modelContext
    @State private var showClipboard = false // Track whether clipboard view is open
    @State private var showArabicNumbers = false // Controls navigation to Arabic Numbers Keyboard
//    @State private var showArabicSymbols = false // Controls navigation to Arabic Symbols Keyboard
    @Binding var showArabicKeyboard: Bool
    @Binding var showArabicSymbols: Bool
    
    // Grouped Keys (Arabic Letters)
    let group1: [(String, [String])] = [
        ("ق ث ص ض ي س ش", ["ق", "ث", "ص", "ض", "ي", "س", "ش"]),
        ("ع  غ  ف  ت  ا  ل ب", ["ع", "غ", "ف", "ت", "ا", "ل", "ب"]),
        ("ج  ح  خ  ة  ك  م  ن", ["ج", "ح", "خ", "ة", "ك", "م", "ن"])
    ]
    
    let group2: [(String, [String])] = [
        ("چ  هـ  ڤ  گ  پ  ؤ  ژ", ["چ", "هـ", "ڤ", "گ", "پ", "ؤ", "ژ"]),
        ("ر   ز   د   ذ  ط  ظ  ء", ["ر", "ز", "د", "ذ", "ط", "ظ", "ء"]),
        ("ى  و  ه  أ  إ  آ  ئ", ["ى", "و", "ه", "أ", "إ", "آ", "ئ"])
    ]
    // Tashkeel Button Group
    let tashkeel: [(String, String)] = [
        ("َ ",""),
        ("ً ",""),
        ("ِ ",""),
        ("ٍ ",""),
        ("ُ  ",""),
        ("ٌ  ",""),
        ("ْ ",""),
        //           ("ّ ","")
        //           ("ـ  ", "")
    ]
    
    
    var body: some View {
            VStack (spacing: 5) { // Main vertical stack
                // Top Bar
//                if !showClipboardKeys {
//                    TopBarView(
//                        proxy: proxy,
//                        predictions: $predictions,
//                        showClipboard: $showClipboard,
//                        showClipboardKeys: $showClipboardKeys
//                    )
//                    .padding(.bottom)
//                }
                if showArabicNumbers { // Check if numbers keyboard should be displayed
                    ArabicNumbers(proxy: proxy, showKeyboardview: $showArabicNumbers, showArabicSymbols: $showArabicSymbols) // Go to Numbers Keyboard
                    
                    // Main content - Conditional Views
                } else if showArabicSymbols {
                    ArabicSymbols(proxy: proxy, showArabicSymbols: $showArabicSymbols)
                }
                
                else if showClipboardKeys {
                    // Show clipboard layout
                    ClipboardKeysView(
                        proxy: proxy,
                        showClipboardKeys: $showClipboardKeys
                    )
                } else if showEnlargedKeys {
                    // Show enlarged keys layout
                    VStack {
                        ZStack {
                            keysTemplate(
                                keys: enlargedKeys,
                                proxy: proxy,
                                showEnlargedKeys: $showEnlargedKeys
                            )
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
                                        .frame(width: 75, height: 51)
                                        .background(Color(.systemGray2))
                                        .font(.system(size: 30))
                                        .cornerRadius(8)
                                        .foregroundStyle(.black)
                                }
                            }
                            .padding(.top, 104)
                            .padding(.leading, 296)

                        }
                        // Bottom buttons for space, tashkeel, return
                        HStack {
                            Button(action: {
                                enlargedKeys = tashkeel.map { $0.0 }
                                showEnlargedKeys = true
                            }) {
                                Text(" ً     ")
                                    .frame(width: 56, height: 47)
                                    .font(.system(size: 45))
                                    .background(Color(.systemGray2))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.leading, -5)
                            }

                            // Space Bar
                            Button("مسافة") {
                                proxy.insertText(" ")
                            }
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .foregroundStyle(.black)
                            
                            // Return Key
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
                    }
                    .padding(.bottom, -120)
                } else {
                    // Default keyboard layout
                    VStack (spacing: 10) {
                        // Group 1
                        HStack {
                            ForEach(group1, id: \.0) { key, keys in
                                Button(action: {
                                    enlargedKeys = keys
                                    showEnlargedKeys = true
                                }) {
                                    Text(key)
                                        .frame(width: 119, height: 90)
                                        .font(.system(size: 25))
                                        .background(Color(.white))
                                        .cornerRadius(8)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        
                        // Group 2
                        HStack {
                            ForEach(group2, id: \.0) { key, keys in
                                Button(action: {
                                    enlargedKeys = keys
                                    showEnlargedKeys = true
                                }) {
                                    Text(key)
                                        .frame(width: 119, height: 90)
                                        .background(Color(.white))
                                        .font(.system(size: 25))
                                        .cornerRadius(8)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        .padding(.bottom, -15)
                        
                        // Special Buttons Row
                        HStack {
                            Button(action: {
                                enlargedKeys = tashkeel.map { $0.0 }
                                showEnlargedKeys = true
                            }) {
                                Text(" ً     ")
                                    .frame(width: 65, height: 51)
                                    .font(.system(size: 45))
                                    .background(Color(.systemGray2))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.leading, -5)
                            }
                            
//                            NavigationLink {
//                                ArabicNumbers(proxy: proxy, showKeyboardview: $showKeyboardview)
//                                    .navigationBarBackButtonHidden(true)
//                            } label: {
//                                Text("١ ٢ ٣")
//                                    .frame(width: 134, height: 51)
//                                    .background(Color(.systemGray2))
//                                    .font(.system(size: 25))
//                                    .cornerRadius(8)
//                                    .foregroundStyle(.black)
//                            }

                            Button("١ ٢ ٣") {
                                showArabicNumbers = true // Activate Numbers Keyboard
                            }
                            .frame(maxWidth: .infinity, maxHeight: 51)
                            .background(Color(.systemGray2))
                            .font(.system(size: 25))
                            .cornerRadius(8)
                            .foregroundStyle(.black)
                            
                            
                            Button("#+=") {
                                showArabicSymbols = true // Navigate to ArabicSymbols
                                showKeyboardview = false // Activate Numbers Keyboard
                            }
                            .frame(width: 67, height: 51)
                            .background(Color(.systemGray2))
                            .font(.system(size: 20))
                            .cornerRadius(8)
                            .foregroundStyle(.black)

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
                            .padding(.trailing, -5)
                        }
                        .padding(.top)

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
                    .padding(.horizontal)
                    .padding(.bottom, -100)
                }
            }
            .background(Color(.systemGray4))
            .frame(height: 415)
//        }
//        .frame(height: 470) // Fixed height for the keyboard
        
    }
    //Top Bar View
//    struct  rView: View {
//        @State var proxy: UITextDocumentProxy
//        @Binding var predictions: [String]
//        @Binding var showClipboard: Bool
//        @Binding var showClipboardKeys: Bool
//
//        @State private var context: String = ""
//        @State private var timer: Timer? = nil // Timer to monitor input changes
//
//        var body: some View {
//            HStack {
//                // Left Predictive Text
//                Button(predictions[0]) {
//                    proxy.insertText(predictions[0] + " ")
//                }
//                .frame(maxWidth: .infinity, maxHeight: 46)
//                .foregroundStyle(.black)
//                .font(.system(size: 25))
//
//                // Divider Line
//                Divider()
//                    .frame(height: 30)
//                    .background(Color(.systemGray3))
//
//                // Clipboard Button
//                Button(action: {
//                    showClipboardKeys = true // Show enlarged clipboard layout
//                }) {
//                    Image(systemName: "list.clipboard")
//                        .font(.system(size: 30))
//                        .frame(width: 56, height: 55)
//                        .background(Color(.systemGray2))
//                        .cornerRadius(8)
//                        .foregroundStyle(.black)
//                }
//                //                .sheet(isPresented: $showClipboard) {
//                //                    ClipboardView(proxy: proxy) // Show ClipboardView
//                //                }
//                //                .padding(.horizontal)
//
//                // Divider Line
//                Divider()
//                    .frame(height: 30)
//                    .background(Color(.systemGray3))
//
//                // Right Predictive Text
//                Button(predictions[1]) {
//                    proxy.insertText(predictions[1] + " ")
//                }
//                .frame(maxWidth: .infinity, maxHeight: 46)
//                .foregroundStyle(.black)
//                .font(.system(size: 25))
//            }
//            .padding(.horizontal)
//            .padding(.top)
//            .onAppear {
//                startMonitoringContext() // Start context monitoring when loaded
//            }
//        }
//        // Prediction Logic
//        func updatePredictions(from context: String?) {
//            guard let context = context, !context.isEmpty else {
//                predictions = ["I", "We"] // Default predictions
//                return
//            }
//
//            let words = context.split(separator: " ")
//            let lastWord = words.last?.lowercased() ?? ""
//
//            // Example static predictions based on the last word
//            switch lastWord {
//            case "a":
//                predictions = ["and", "about"]
//            case "b":
//                predictions = ["before", "bye"]
//            case "c":
//                predictions = ["card", "cold"]
//            case "d":
//                predictions = ["do", "door"]
//            case "i":
//                predictions = ["I'm", "is"]
//            case "h":
//                predictions = ["hi", "hello"]
//            case "he":
//                predictions = ["hey", "hello"]
//            case "you":
//                predictions = ["are", "will"]
//            case "we":
//                predictions = ["are", "can"]
//            case "he ":
//                predictions = ["is", "was"]
//            case "she":
//                predictions = ["is", "was"]
//            case "it":
//                predictions = ["is", "will"]
//            default:
//                predictions = ["I", "The"]
//            }
//        }
//
//        // Monitor Context Changes
//        func startMonitoringContext() {
//            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
//                let currentContext = proxy.documentContextBeforeInput ?? ""
//                if currentContext != context { // Check if context has changed
//                    context = currentContext // Update context
//                    updatePredictions(from: context) // Update predictions
//                }
//            }
//        }
//
//    }
    
    struct ClipboardKeysView: View {
        @Environment(\.modelContext) private var modelContext // Access the shared database context
        @State private var savedPhrases: [Phrase] = [] // Use state to hold data locally
        
        var proxy: UITextDocumentProxy
        @Binding var showClipboardKeys: Bool // Toggle back to main view
        
        var body: some View {
            VStack {
                // Top Bar with Back Button
                topBar
                
                // Display Saved Phrases
                savedPhrasesTabView
                
                // Display Saved Phrases in Separate Buttons
                //            savedPhrasesList
            }
            .padding(.bottom, -100)
        }
        
        // MARK: - Top Bar View
        private var topBar: some View {
            HStack {
                Button(action: {
                    showClipboardKeys = false // Go back to main keyboard
                }) {
                    HStack {
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
                }
                Spacer()
            }
            .padding(.bottom, 10)
        }
        
        // MARK: - Saved Phrases Tab View
        private var savedPhrasesTabView: some View {
            TabView {
                // "+" Button
                Text("+")
                    .frame(width: 150, height: 100)
                    .font(.system(size: 30))
                    .foregroundStyle(Color.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.leading, -180)
                    .padding(.top, -150)
                
                // Display chunks of saved phrases
                //            ForEach(savedPhrases.chunked(into: 3), id: \.self) { chunk in
                //                VStack(spacing: 10) {
                //                    ForEach(chunk) { phrase in
                //                        savedPhraseButton(for: phrase)
                //                    }
                //                }
                //            }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 300) // Set height for pages
            .padding()
        }
        
        //    // MARK: - Saved Phrases List
        //    private var savedPhrasesList: some View {
        //        ForEach(savedPhrases, id: \.self) { phrase in
        //            savedPhraseButton(for: phrase)
        //        }
        //    }
        //
        //    // MARK: - Saved Phrase Button
        //    private func savedPhraseButton(for phrase: Phrase) -> some View {
        //        Button(action: {
        //            proxy.insertText(phrase.content + " ")
        //        }) {
        //            Text(phrase.content)
        //                .frame(width: 150, height: 100)
        //                .background(Color.white)
        //                .font(.system(size: 25))
        //                .cornerRadius(8)
        //                .foregroundStyle(.black)
        //                .padding(5)
        //        }
        //    }
        
        //    var body: some View {
        //        VStack {
        //            // Top Bar with Back Button
        //            HStack {
        //                Button(action: {
        //                    showClipboardKeys = false // Go back to main keyboard
        //                }) {
        //                    Image(systemName: "chevron.left")
        //                        .font(.system(size: 24))
        //                        .padding(.leading)
        //                        .padding(.top, 30)
        //                        .foregroundStyle(Color.black)
        //                    Text("Back")
        //                        .font(.system(size: 20))
        //                        .padding(.top, 30)
        //                        .foregroundStyle(Color.black)
        //                }
        //                Spacer()
        //            }
        //            .padding(.bottom, 10)
        //
        //            // Display Saved Phrases
        //            TabView {
        //                Text("+")
        //                    .frame(width: 150, height: 100)
        //                    .font(.system(size: 30))
        //                    .foregroundStyle(Color.black)
        //                    .background(Color.white)
        //                    .cornerRadius(10)
        //                    .padding(.leading, -180)
        //                    .padding(.top, -150)
        //                ForEach(savedPhrases.chunked(into: 3), id: \.self) { chunk in
        //                    VStack(spacing: 10) {
        //                        ForEach(chunk) { phrase in
        //                            Button(action: {
        //                                proxy.insertText(phrase.content + " ")
        //                            }) {
        //                                Text(phrase.content)
        //                                    .frame(width: 150, height: 100)
        //                                    .background(Color.white)
        //                                    .font(.system(size: 25))
        //                                    .cornerRadius(8)
        //                                    .foregroundStyle(.black)
        //                                    .padding(5)
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        //            .frame(height: 300) // Set height for pages
        //            .padding()
        //            ForEach(savedPhrases, id: \.self) { phrase in
        //                Button(action: {
        //                    proxy.insertText(phrase.content + " ")
        //                }) {
        //                    Text(phrase.content)
        //                        .frame(width: 150, height: 100)
        //                        .background(Color.white)
        //                        .font(.system(size: 25))
        //                        .cornerRadius(8)
        //                        .foregroundStyle(.black)
        //                        .padding(5)
        //                }
        //            }
        //        }
        //        .onAppear {
        //            fetchPhrases()
        //        }
        
    }
    //    func fetchClipboardPhrases() {
    //        let fetchDescriptor = FetchDescriptor<Phrase>()
    //        do {
    //            savedPhrases = try modelContext.fetch(fetchDescriptor) // Fetch phrases
    //            print("Fetched phrases: \(savedPhrases)") // Debug log
    //        } catch {
    //            print("Failed to fetch phrases: \(error)") // Debug log
    //        }
    //    }
    //    func fetchPhrases() {
    //        // Fetch saved phrases from SwiftData model context
    //        let fetchDescriptor = FetchDescriptor<Phrase>() // Fetch all Phrase objects
    //        do {
    //            let phrases = try modelContext.fetch(fetchDescriptor)
    //            print("Fetched phrases: \(phrases)") // Debug output
    //        } catch {
    //            print("Failed to fetch phrases: \(error)") // Handle errors
    //        }
    //    }
    //}
    
    
    
    
    func keysTemplate(keys: [String], proxy: UITextDocumentProxy, showEnlargedKeys: Binding<Bool>) -> some View {
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
}
