//
//  LabelBasedInputField.swift
//  CodeInputView
//
//  Created by Isa Aliev on 24.03.18.
//  Copyright © 2018 IA. All rights reserved.
//

import Foundation
import UIKit

open class LabelBasedInputField: UILabel, InputableField {
    public struct Configuration {
        public typealias AppearanceBlock = (UILabel) -> ()
        
        public var onLayoutAppearanceBlock: AppearanceBlock?
        public var initialAppearanceBlock: AppearanceBlock?
        public var emptyAppearanceBlock: AppearanceBlock?
        public var filledAppearanceBlock: AppearanceBlock?
    }

    
    private var value: String?
    
    public static var configuration: LabelBasedInputField.Configuration? = LabelBasedInputField.Configuration()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        LabelBasedInputField.configuration?.initialAppearanceBlock?(self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        LabelBasedInputField.configuration?.onLayoutAppearanceBlock?(self)
    }
    
    open func deleteValue() {
        LabelBasedInputField.configuration?.initialAppearanceBlock?(self)
        LabelBasedInputField.configuration?.emptyAppearanceBlock?(self)
        value = ""
        text = nil
    }
    
    open func setValue(_ newValue: String) {
        LabelBasedInputField.configuration?.initialAppearanceBlock?(self)
        LabelBasedInputField.configuration?.filledAppearanceBlock?(self)
        value = newValue
        text = newValue
    }
    
    open func getValue() -> String {
        return value ?? ""
    }
    
    open func isEmpty() -> Bool {
        return value == nil
    }
    
}
