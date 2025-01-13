//
//  KeyboardViewController.swift
//  EnlargedKeysArabic
//
//  Created by Maryam Amer Bin Siddique on 02/07/1446 AH.
//

import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {

    // Use a regular Swift variable to track state
    private var isShowingArabicNumbers = false
    private var isShowingArabicSymbols = false

    @IBOutlet var nextKeyboardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the initial keyboard view
        loadKeyboardView()

        // Setup the next keyboard button
        nextKeyboardButton = UIButton(type: .system)
        nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

        view.addSubview(nextKeyboardButton)

        NSLayoutConstraint.activate([
            nextKeyboardButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            nextKeyboardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadKeyboardView() {
//        let contentView: AnyView
//
//        // TopBarView - Shared Component
//        let topBar = TopBarView(
//            proxy: self.textDocumentProxy,
//            predictions: .constant(["Hello", "Hi"]), // Replace this with your actual logic
//            showClipboard: .constant(false),
//            showClipboardKeys: .constant(false)
//        )
//
//        if isShowingArabicNumbers {
//            // Arabic Numbers Keyboard
//            contentView = AnyView(
//                VStack(spacing: 0) { // Use VStack to stack TopBar only if Arabic Keyboard
//                    topBar
//                    ArabicNumbers(
//                        proxy: self.textDocumentProxy,
//                        showKeyboardview: Binding(
//                            get: { self.isShowingArabicNumbers },
//                            set: { self.isShowingArabicNumbers = $0 }
//                        ),
//                        showArabicSymbols: Binding( // <-- Ensure this matches the ArabicNumbers View
//                            get: { self.isShowingArabicSymbols },
//                            set: { self.isShowingArabicSymbols = $0 }
//                        )
//                    )
//                }
//            )
//        } else if isShowingArabicSymbols {
//            // Arabic Symbols Keyboard
//            contentView = AnyView(
//                VStack(spacing: 0) { // Use VStack to stack TopBar only if Arabic Keyboard
//                    topBar
//                    ArabicSymbols(
//                        proxy: self.textDocumentProxy,
//                        showArabicSymbols: Binding(
//                            get: { self.isShowingArabicSymbols },
//                            set: { self.isShowingArabicSymbols = $0 }
//                        )
//                    )
//                }
//            )
//
//        } else {
//            // Arabic Letters Keyboard with TopBar
//            contentView = AnyView(
//                VStack(spacing: 0) { // Use VStack to stack TopBar
//                    topBar // Add TopBar only for Arabic Letters Keyboard
//                    Keyboardview(
//                        proxy: self.textDocumentProxy,
//                        showKeyboardview: Binding(
//                            get: { self.isShowingArabicNumbers },
//                            set: { self.isShowingArabicNumbers = $0 }
//                        ),
//                        showArabicKeyboard: Binding(
//                            get: { self.isShowingArabicNumbers },
//                            set: { self.isShowingArabicNumbers = $0 }
//                        ),
//                        showArabicSymbols: Binding( // <-- Ensure this matches the updated struct
//                            get: { self.isShowingArabicSymbols },
//                            set: { self.isShowingArabicSymbols = $0 }
//                        )
//                    )
//                }
//            )
//        }
        let contentView: AnyView = AnyView(
            VStack(spacing: 0) {
                TopBarView(
                    proxy: self.textDocumentProxy,
                    predictions: .constant(["مرحبا", "انا"]),
                    showClipboard: .constant(false),
                    showClipboardKeys: .constant(false)
                )
                if isShowingArabicNumbers {
                    ArabicNumbers(
                        proxy: self.textDocumentProxy,
                        showKeyboardview: Binding(
                            get: { self.isShowingArabicNumbers },
                            set: { self.isShowingArabicNumbers = $0 }
                        ),
                        showArabicSymbols: Binding(
                            get: { self.isShowingArabicSymbols },
                            set: { self.isShowingArabicSymbols = $0 }
                        )
                    )
                } else if isShowingArabicSymbols {
                    ArabicSymbols(
                        proxy: self.textDocumentProxy,
                        showArabicSymbols: Binding(
                            get: { self.isShowingArabicSymbols },
                            set: { self.isShowingArabicSymbols = $0 }
                        )
                    )
                } else {
                    Keyboardview(
                        proxy: self.textDocumentProxy,
                        showKeyboardview: Binding(
                            get: { self.isShowingArabicNumbers },
                            set: { self.isShowingArabicNumbers = $0 }
                        ),
                        showArabicKeyboard: Binding(
                            get: { self.isShowingArabicNumbers },
                            set: { self.isShowingArabicNumbers = $0 }
                        ),
                        showArabicSymbols: Binding(
                            get: { self.isShowingArabicSymbols },
                            set: { self.isShowingArabicSymbols = $0 }
                        )
                    )
                }
            }
        )
        // Hosting Controller Setup
        let hostingController = UIHostingController(rootView: contentView)
        let keyboardView = hostingController.view!
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.backgroundColor = .systemGray4

        // Add to View Hierarchy
        addChild(hostingController)
        view.addSubview(keyboardView)

        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.06)
        ])

        hostingController.didMove(toParent: self)
    }
    
//    func loadKeyboardView() {
//        // Create the appropriate SwiftUI view based on the current state
//        let contentView: AnyView
//        if isShowingArabicNumbers {
//            contentView = AnyView(ArabicNumbers(
//                proxy: self.textDocumentProxy,
//                showKeyboardview: Binding( // <-- Corrected the argument name
//                    get: { self.isShowingArabicNumbers },
//                    set: { self.isShowingArabicNumbers = $0 } // Toggle the state
//                )
//            ))
//        } else {
//            contentView = AnyView(Keyboardview(
//                proxy: self.textDocumentProxy,
//                showKeyboardview: Binding( // <-- Corrected the argument name
//                    get: { self.isShowingArabicNumbers },
//                    set: { self.isShowingArabicNumbers = $0 } // Toggle the state
//                                         ),     showArabicKeyboard: Binding( // Fixed: Binds showArabicKeyboard too
//                                            get: { self.isShowingArabicNumbers },
//                                            set: { self.isShowingArabicNumbers = $0 }
//                                        )
//
//            ))
//        }
//
//        // Create the hosting controller
//        let hostingController = UIHostingController(rootView: contentView)
//        let keyboardView = hostingController.view!
//        keyboardView.translatesAutoresizingMaskIntoConstraints = false
//        keyboardView.backgroundColor = .systemGray4
//
//        // Add to view hierarchy
//        addChild(hostingController)
//        view.addSubview(keyboardView)
//
//        NSLayoutConstraint.activate([
//            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            keyboardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0)
//        ])
//
//        hostingController.didMove(toParent: self)
//    }
//

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nextKeyboardButton.isHidden = !needsInputModeSwitchKey
    }

    override func textWillChange(_ textInput: UITextInput?) {
        // Handle text changes if needed
    }

    override func textDidChange(_ textInput: UITextInput?) {
        let proxy = textDocumentProxy
        let textColor: UIColor = (proxy.keyboardAppearance == .dark) ? .white : .black
        nextKeyboardButton.setTitleColor(textColor, for: [])
    }
}
