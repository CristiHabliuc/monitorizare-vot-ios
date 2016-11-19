//
//  MVUITextView.swift
//
//
//  Created by Andrei Nastasiu on 24/06/16.
//  Copyright © 2016 Andrei Nastasiu. All rights reserved.
//

import Foundation
import UIKit

protocol MVUITextViewDelegate: class {
    func textView(textView: MVUITextView, didChangeText: String)
}

class MVUITextView: UITextView, UITextViewDelegate {
 
    // MARK: - iVars
    var placeholder = "" {
        didSet {
            emptyTextFieldLayout()
        }
    }
    weak var customDelegate: MVUITextViewDelegate?
    private var isEmpty = true

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
    
    // MARK: - Utils
    func clear() {
        self.text = ""
    }
    
    func dismissKeyboad() {
        self.resignFirstResponder()
    }
    
    private func emptyTextFieldLayout() {
        self.font = UIFont.systemFont(ofSize: 17.0)
        self.textColor = UIColor.gray
        self.text = placeholder
        isEmpty = true
        
        self.selectedTextRange = self.textRange(from: self.beginningOfDocument, to: self.beginningOfDocument)
    }

    private func notEmptyTextFieldLayout() {
        self.textColor = UIColor.black
        isEmpty = false
    }
    
    // MARK: - UITextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0 && isEmpty {
            emptyTextFieldLayout()
        } else {
            notEmptyTextFieldLayout()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" && isEmpty {
            return false
        }
    
        if (textView.text.characters.count <= 1 || isEmpty) && text == "" {
            self.emptyTextFieldLayout()
            self.isEmpty = true
        } else if (textView.text == placeholder && isEmpty && text != "") {
            notEmptyTextFieldLayout()
            textView.text = ""
            isEmpty = false
        } else {
            notEmptyTextFieldLayout()
            isEmpty = false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isEmpty {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            emptyTextFieldLayout()
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if isEmpty {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
}