//
//  IACodeInputView.swift
//  CodeInputView
//
//  Created by Isa Aliev on 15.03.18.
//  Copyright © 2018 IA. All rights reserved.
//

import Foundation
import UIKit

open class IACodeInputView<T: InputableField>: UIView, UIKeyInput {
    public var fields = [T]()
    public var currentIndex = 0
    public var numberOfFields = 4 {
        didSet {
            configure()
            layoutSubviews()
        }
    }
    
    open var code = ""
    public var horizontalMargins: CGFloat = 8.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    public var interFieldSpacing: CGFloat = 8.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    public var keyboardType: UIKeyboardType = .numberPad
    
    public var onCodeDidEnter: ((String) -> ())?
    
    private var sizeOfField: CGFloat {
        let frameWidth = frame.width
        let minBySides = min(frameWidth - horizontalMargins * 2, frame.height * 0.8)
        let fieldsCount = fields.count
        
        return min(minBySides, (frameWidth - interFieldSpacing * CGFloat(fieldsCount - 1) - horizontalMargins * 2.0)/CGFloat(fieldsCount))
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open var hasText: Bool {
        return fields.filter({ !$0.isEmpty() }).count > 0
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFields()
    }
    
    private func configure() {
        guard fields.count != numberOfFields else { return }
        
        let fieldCount = fields.count
        if numberOfFields > fields.count {
            (0..<(numberOfFields - fields.count)).forEach({ pos in
                insertNewField(pos + fieldCount)
            })
        } else {
            fields[numberOfFields..<fields.count].forEach({ $0.removeFromSuperview() })
            fields.removeSubrange(numberOfFields..<fields.count)
        }
    }
    
    open func insertNewField(_ index: Int) {
        let field = T(frame: fields.last?.frame ?? .zero)
        addSubview(field)
        fields.append(field)
    }
    
    private func layoutFields() {
        let numberOfFields = fields.count
        let widthOfFields = CGFloat(numberOfFields) / 2.0 * sizeOfField
        let widthOfInterFieldSpacing = (CGFloat(numberOfFields) / 2.0 - 0.5) * interFieldSpacing
        var x = bounds.midX - (widthOfFields + widthOfInterFieldSpacing)
        let y = (bounds.height - sizeOfField) * 0.5

        fields.forEach({
            let frame = CGRect(x: x, y: y, width: sizeOfField, height: sizeOfField)
            $0.frame = frame
            x += sizeOfField + interFieldSpacing
        })
    }
    
    open func clear() {
        fields.forEach({ $0.deleteValue() })
        updateCode()
        currentIndex = 0
    }
    
    open func insertText(_ text: String) {
        guard currentIndex < fields.count else {
            return
        }
        
        fields[currentIndex].setValue(text)
        currentIndex += 1
        updateCode()
    }
    
    open func deleteBackward() {
        guard currentIndex > 0 else {
            return
        }
        
        currentIndex -= 1
        fields[currentIndex].deleteValue()
        updateCode()
    }
    
    open func updateCode() {
        code = fields.reduce("", { $0 + $1.getValue() })
        if code.count == numberOfFields {
            onCodeDidEnter?(code)
        }
    }
}

